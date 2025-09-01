#! /usr/bin/env ruby

HERE = (File.dirname __FILE__) + "/"

["users", "boards", "shemails"].each {|p|
  Dir.mkdir HERE + p
}

File.write HERE + "boards/index.json", "[\n]"
