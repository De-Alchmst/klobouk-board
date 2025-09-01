require_relative 'fileops'
require_relative 'screen'
require_relative 'user_config'
require_relative 'board'

module Index
  @boards_data = Fileops.get_boards
  @exit = false


  def self.index(user)
    while true
      draw_index
      return if handle_input user
    end
  end

  private

  # TODO: draw_index manage screen size
  def self.draw_index
    Screen.clear
    puts "Uživatel:
  Odejít (q)
  Nastavení účtu (u)

She-Mail: <zatím neimplementováno>
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
    ch = Screen.getch
    puts ch
    case ch
    when 'q'
      return true

    when "\x03" # ^C
      exit 0

    when 'u'
      UserConfig.user_config user
    end

    @boards_data.each {|board|
      if ch == board["key"]
        Board.board user, board
      end
    }

    return false
  end
end
