#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

require 'open-uri'

# Configuration
protocol = 'http'
host = 'localhost'
port = 3000
# End of configuration


if ARGV.empty?
  email, pass = $stdin.read.unpack("Z*Z*")
else
  if ARGV.first == '-v'
    verbose = true
    ARGV.shift
  else
    verbose = false
  end
  email = ARGV.shift
  pass = ARGV.shift
end

name, domain = email.split('@', 2)


begin
  # TODO: validate and escape/encode input.
  # TODO: POST params
  resp = open("#{protocol}://#{host}:#{port}/login.json?name=#{name}&domain=#{domain}&password=#{pass}")
  puts resp.status.last if verbose
  exit 0
rescue OpenURI::HTTPError => exc
  puts exc if verbose
  exit 1
rescue => exc
  # Something went wrong, user will see temporary error.
  puts exc
  exit 111
end

