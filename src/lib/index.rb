require_relative 'fileops'
require_relative 'screen'
require_relative 'user_config'

module Index
  @boards_data = Fileops.get_boards
  @exit = false


  def self.index(user)
    until @exit 
      draw_index
      handle_input user
    end
  end

  private

  # TODO: draw_index manage screen size
  def self.draw_index
    Screen.clear
    puts "Uživatel:
  Odejít (q)
  Nastavení účtu (u)

She-Mail:
  Schránka (s)
  Nová zpráva (z)

Nástěnky:"
    list_boards
  end


  def self.list_boards
    @boards_data.each {|board|
      puts "  /#{board["name"]}/ (#{board["key"]})"
    }
  end


  def self.handle_input(user)
    case Screen.getch
    when 'q'
      @exit=true

    when "\x03" # ^C
      exit 0

    when 'u'
      USER_CONFIG.user_config user
    end
  end
end
