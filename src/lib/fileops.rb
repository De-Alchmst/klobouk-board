require 'json'

HERE   = File.dirname File.dirname __FILE__
USERS  = HERE + "/users/"
BOARDS = HERE + "/boards/"
MAILS  = HERE + "/shemails/"

module Fileops
  def Fileops.get_user_data(name)
    filename = USERS + name
    return {} unless File.readable? filename
    return JSON.parse File.read filename
  end
end
