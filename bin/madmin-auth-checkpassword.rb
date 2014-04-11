# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby

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
