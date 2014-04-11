# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby

require 'sqlite3'
require 'bcrypt'

dbfile = File.join(%W(#{File.dirname(__FILE__)} .. db development.sqlite3))

name, domain = ARGV.shift.split('@', 2)
pass = ARGV.shift

pwsql = "select users.password_digest 
  from users 
  join domains on users.domain_id=domains.id 
  where users.name = '%s' and domains.name = '%s'" % [name, domain]

dbcon = SQLite3::Database.new(dbfile)
pwhash = dbcon.get_first_value(pwsql)
if pwhash.nil?
  puts false
  exit 1
end
bcrypt_pass = BCrypt::Password.new(pwhash)

if bcrypt_pass == pass
  puts 'ok'
  exit 0
else
  puts 'failed'
  exit 1
end
