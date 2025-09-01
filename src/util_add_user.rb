#! /usr/bin/env ruby
require 'bcrypt'
require 'json'

HERE = File.dirname __FILE__
USER_DIR = HERE + "/users/"

if ARGV.count != 2
  puts "usage: ./util_add_user <name> <password>"
  exit 1
end

name = ARGV[0]
pass = ARGV[1]

File.write USER_DIR + name, JSON.pretty_generate({
  password: BCrypt::Password.create(pass)
})
