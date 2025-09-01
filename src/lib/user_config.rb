require 'io/console'

require_relative 'fileops'
require_relative 'screen'

module USER_CONFIG
  @exit = false

  def self.user_config(user)
    until @exit
      draw_config user
      handle_input user
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
      @exit=true

    when "\x03" # ^C
      exit 0

    when 'h'
      new_password(user)
    end
  end
end
