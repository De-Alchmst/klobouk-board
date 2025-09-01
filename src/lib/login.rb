require 'io/console'
require 'bcrypt'

require_relative 'fileops'

module Login
  def Login.login
    while true
      user_data = prompt_username
      return user_data["name"] if prompt_password user_data
      puts "Špatné heslo!"
    end
  end
end


def prompt_username
  while true
    STDIN.echo = true
    print "Jméno: "
    name = STDIN.readline.strip
    data = Fileops.get_user_data name

    return data unless data.empty?
    puts "Jméno nenalezeno..."
  end
end


def prompt_password(user_data)
  password = STDIN.getpass 'Heslo: '
  return BCrypt::Password.new(user_data["password"]) == password
end
