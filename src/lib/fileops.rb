require 'json'
require 'bcrypt'

# board entry file structure:
# <title>
# ;;
# {
#   "author": <author>
#   "time": <time>
#   "contents": <contents>
# }
# ;;
# ...

module Fileops
  HERE   = File.dirname File.dirname __FILE__
  USERS  = HERE + "/users/"
  BOARDS = HERE + "/boards/"
  MAILS  = HERE + "/shemails/"

  def self.get_user_data(name)
    read_json USERS + name
  end


  def self.get_boards
    boards_data = read_json BOARDS + "index.json"
    boards_data.each {|board|
      path = BOARDS + board["name"]
      unless File.readable? path
        Dir.mkdir path
        File.write path + "/next_id", "0"
      end
    }
    return boards_data
  end


  def self.change_password(user_data, password)
    user_data["password"] = BCrypt::Password.create password
    File.write USERS + user_data["name"], JSON.pretty_generate(user_data)
  end


  def self.get_board_entries board_data
    path = BOARDS + board_data["name"] + "/"
    # return sorted by time, newest first, ignore 'next_id'
    `ls -t #{path}`.split.filter {|e| e != "next_id"}.map {|name|
      f = File.open path + name
      title = f.readline
      f.close
      {
        "board": board_data,
        "name": name,
        "title": title,
      }
    }
  end

  private

  def self.read_json filename
    return {} unless File.readable? filename
    return JSON.parse File.read filename
  end
end
