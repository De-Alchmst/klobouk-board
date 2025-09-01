require 'json'

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

  private

  def self.read_json filename
    return {} unless File.readable? filename
    return JSON.parse File.read filename
  end
end
