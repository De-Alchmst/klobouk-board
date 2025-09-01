require 'io/console'

require_relative 'fileops'
require_relative 'screen'

module UserConfig
  def self.user_config(user)
    until @exit
      draw_config user
      return if handle_input user
    end
  end

  private

  def self.draw_config(user)
    Screen.clear
    puts "Jméno: " + user["name"]
    puts "Heslo (h): [REDAKTOVÁNO]"
    puts ""
    puts "Odejít (q)"
  end


  def self.new_password(user)
    Screen.clear
    pass1 = STDIN.getpass "Nové heslo: "
    pass2 = STDIN.getpass "A ještě jednou: "

    if pass1 != pass2
      puts "Hesla se neschodují..."
    else
      puts "Heslo změněno!"
      Fileops.change_password user, pass1
    end
    Screen.getch
  end


  def self.handle_input(user)
    case Screen.getch
    when 'q'
      return true

    when "\x03" # ^C
      exit 0

    when 'h'
      new_password(user)
    end
    return false
  end
end
