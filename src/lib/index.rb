require 'io/console'

require_relative 'fileops'
require_relative 'screen'

module Index
  @boards_data = Fileops.get_boards
  @exit = false


  def self.index(user)
    until @exit 
      draw_index
      handle_input
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


  def self.handle_input
    STDIN.echo = false
    ch = STDIN.getch

    case ch
    when 'q', "\x03" # ^C
      @exit=true
    end
  end
end
