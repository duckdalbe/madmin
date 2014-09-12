#!/usr/bin/env ruby

## Config

UserHome = '/tmp/'
UserUid  = 111
UserGid  = 8

## Setup

require 'mysql2'
require 'bcrypt'
require 'yaml'

def fetch_user(email)
  name, domain = email.split('@', 2)
  sql = "select users.password_digest 
    from users 
    join domains on users.domain_id=domains.id 
    where users.name = '%s' and domains.name = '%s'" % [name, domain]
  dbfile = File.join(File.dirname(__FILE__), '..', 'config', 'database.yml')
  dbconf = YAML.load(File.read(dbfile))['production']
  dbh = Mysql2::Client.new(
        host: dbconf['host'],
        username: dbconf['username'],
        password: dbconf['password'],
        database: dbconf['database']
      )
  dbh.query(sql).first
end

def checkpassword(user, password)
  # TODO: check old hash, migration from it
  BCrypt::Password.new(user['password_digest']) == password
end

def dovecot_env(email)
  vars = {
    USER: email,
    HOME: UserHome,
    EXTRA: 'userdb_uid userdb_gid',
    userdb_uid: UserUid,
    userdb_gid: UserGid
  }

  vars.map do |k,v|
    "#{k}='#{v}'"
  end.join(' ')
end

### Start script

dovecot_reply_arg = ARGV[0]
InternalAuthError = 111
AuthError         = 1

begin
  IO.new(3, 'r') do |io|
    @email, @password = io.read.unpack("Z*Z*")
  end

  user = fetch_user(@email)

  if user.nil? || ! checkpassword(user, @password)
    exit AuthError
  end
rescue
  # TODO: log errors
  exit InternalAuthError
end

exec "#{dovecot_env(@email)} #{dovecot_reply_arg}"
