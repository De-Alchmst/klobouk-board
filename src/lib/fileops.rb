require 'json'
require 'bcrypt'

# board entry file structure:
# <title>
# ;;
# {
#   "author": <author>,
#   "time": <time>,
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
    return `ls -t #{path}`.split.filter {|e| e != "next_id"}.map {|name|
      f = File.open path + name
      title = f.readline.strip
      f.close

      {
        "board" => board_data,
        "name"  => name,
        "title" => title,
      }
    }
  end


  def self.write_new_entry(user_data, board_data, contents)
    title = contents.split("\n")[0]
    id = get_next_id board_data["name"]
    File.write BOARDS + board_data["name"] + "/" + id.to_s,
      title + "\n;;\n" + JSON.pretty_generate({
        "author": user_data["name"],
        "time": get_time,
        "contents": contents
      })
  end

  private

  def self.read_json filename
    return {} unless File.readable? filename
    return JSON.parse File.read filename
  end


  def self.get_next_id(board)
    f = File.open BOARDS + board + "/next_id", "r+"
    id = f.read.to_i
    f.rewind
    f.write "#{id+1}"
    f.close
    return id
  end


  def self.get_time
    # Tento formát je validní!
    # https://prirucka.ujc.cas.cz/?id=810
    Time.now.getlocal("+02:00").strftime("%d.%m.%Y %H:%M")
  end
end
