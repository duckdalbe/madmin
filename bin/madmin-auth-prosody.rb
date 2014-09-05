#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

require 'mysql2'
require 'bcrypt'
require 'yaml'

dbconf = YAML.load(File.read('../config/database.yml'))['production']
dbh = Mysql2::Client.new(
      host: dbconf['host'],
      username: dbconf['username'],
      password: dbconf['password'],
      database: dbconf['database']
    )

def fail(errcode=1)
  puts 0
  exit errcode
end

def ok
  puts 1
  exit 0
end

action, name, domain, password = $stdin.read.chomp.split(':')

if action != 'auth'
  fail 1
end

sql = "select users.password_digest 
  from users 
  join domains on users.domain_id=domains.id 
  where users.name = '%s' and domains.name = '%s'" % [name, domain]

if (res = dbh.query(sql).first).nil?
  fail 1
end

bcrypt_pass = BCrypt::Password.new(res['password_digest'])

if bcrypt_pass == password
  # OK
  ok
else
  # Failed
  fail 1
end
