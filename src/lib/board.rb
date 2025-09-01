require_relative 'fileops'
require_relative 'screen'
require_relative 'post_help'
require_relative 'entry_handle'

module Board
  HELP_BAR_TEXT = \
    "Pomoc (h) | Nový (n) | Posunout (↑↓) | Vybrat | (↵) | Odejít (q)"
  @entries = []
  @width = 0
  @taken_by_title = 0
  @title_lines = []

  def self.board(user, board)
    reset_board board
    while true
      draw_board board
      return if handle_input user, board
    end
  end

  private

  def self.reset_board board
    @entries = Fileops.get_board_entries(board)
    @width = 0
  end

  def self.draw_board(board)
    Screen.clear

    width = Screen.width
    if width != @width
      @width = width
      setup_title board
    end

    print_title
   
    if @entries.empty?
      puts "Tahle nástěnka je prázdná jak moje peněženka. " \
         + "Co takhle to napravit?"
             end

    print_help_bar
  end


  def self.print_title
    @title_lines.each {|line| puts line}
  end


  def self.setup_title(board)
    @title_lines = [ Screen.center(board["name"]) ]
    Screen.parse_text(board["description"]).each {|line|
      @title_lines << Screen.center(line) 
    }
  end


  def self.print_help_bar
    print "\e[#{Screen.height};0H#{HELP_BAR_TEXT[(..@width-1)]}"
  end


  def self.handle_input(user, board)
    ch = Screen.getch
    case ch
    when "q"
      return true

    when "\x03"
      exit 0

    when "h"
      PostHelp.post_help

    when "n"
      EntryHandle.new_entry user, board
      reset_board board
      
    end
    return false
  end
end
