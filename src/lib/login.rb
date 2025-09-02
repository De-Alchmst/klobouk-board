require 'io/console'
require 'bcrypt'

require_relative 'fileops'

module Login
  def self.login
    while true
      user_data = prompt_username
      return user_data if prompt_password user_data
      puts "Špatné heslo!"
    end
  end

  private

  def self.prompt_username
    while true
      STDIN.echo = true
      print "Jméno: "
      name = STDIN.readline.strip
      data = Fileops.get_user_data name

      return data unless data.empty?
      puts "Jméno nenalezeno..."
    end
  end


  def self.prompt_password(user_data)
    # .strip does not strip 0 on my server implementation for some reason
    password = STDIN.getpass('Heslo: ').strip.gsub "\u0000", ""
    return BCrypt::Password.new(user_data["password"]) == password
  end
end
