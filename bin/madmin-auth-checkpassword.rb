#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

require 'mysql2'
require 'bcrypt'
require 'yaml'

dbfile = File.join(File.dirname(__FILE__), '..', 'config', 'database.yml')
dbconf = YAML.load(File.read(dbfile))['production']
dbh = Mysql2::Client.new(
      host: dbconf['host'],
      username: dbconf['username'],
      password: dbconf['password'],
      database: dbconf['database']
    )

name = ENV['AUTH_USERNAME']
domain = ENV['AUTH_DOMAIN']
password = ENV['AUTH_PASSWORD']

sql = "select users.password_digest 
  from users 
  join domains on users.domain_id=domains.id 
  where users.name = '%s' and domains.name = '%s'" % [name, domain]

if (res = dbh.query(sql).first).nil?
  #puts false
  exit 1
end

bcrypt_pass = BCrypt::Password.new(res['password_digest'])

if bcrypt_pass == password
  # OK
  exit 0
else
  # Failed
  exit 1
end
