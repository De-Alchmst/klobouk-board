require_relative 'fileops'
require_relative 'screen'
require_relative 'post_help'

module Board
  HELP_BAR_TEXT = \
    "Pomoc (h) | Nový (n) | Posunout (↑↓) | Vybrat | (↵) | Odejít (q)"
  @exit = false
  @prev_width = 0
  @taken_by_title = 0

  def self.board(user, board)
    entries = Fileops.get_board_entries(board)
    until @exit
      draw_board board, entries
      handle_input user, entries
    end
  end

  private

  def self.draw_board(board, entries)
    Screen.clear

    width = Screen.width
    if width != @width
      @width = width
      print_title board
    end

    if entries.empty?
      puts "Tahle nástěnka je prázdná jak moje peněženka. " \
         + "Co takhle to napravit?"
             end

    print_help_bar
  end


  def self.print_title(board)
    width = Screen.width
    Screen.puts_center board["name"]

    lines = Screen.parse_text board["description"]
    lines.each {|line|
      Screen.puts_center line
    }

    @taken_by_title = 1 + lines.count
  end


  def self.print_help_bar
    print "\e[#{Screen.height-1};0H#{HELP_BAR_TEXT[(..@width-1)]}"
  end


  def self.handle_input(user, entries)
    ch = Screen.getch
    case ch
    when "q"
      @exit = true

    when "\x03"
      exit 0

    when "h"
      PostHelp.post_help
      
    end
  end
end
