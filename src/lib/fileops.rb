require 'json'
require 'bcrypt'

module Fileops
  HERE   = File.dirname File.dirname __FILE__
  USERS  = HERE + "/users/"
  BOARDS = HERE + "/boards/"
  MAILS  = HERE + "/shemails/"

  def self.get_user_data(name)
    read_json USERS + name
  end


  def self.get_boards
    read_json BOARDS + "index.json"
  end


  def self.change_password(user_data, password)
    user_data["password"] = BCrypt::Password.create password
    File.write USERS + user_data["name"], JSON.pretty_generate(user_data)
  end

  private

  def self.read_json filename
    return {} unless File.readable? filename
    return JSON.parse File.read filename
  end
end
