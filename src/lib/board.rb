require_relative 'fileops'
require_relative 'screen'
require_relative 'help'
require_relative 'messages'
require_relative 'scroll_select'
require_relative 'entry_display'
require_relative 'scroll_controll'

module Board
  HELP_BAR_TEXT = \
  "Pomoc (h) | Nový (n) | Posunout (↑↓) | Vybrat | (↵) | Odejít (q)"
  @entries = []
  @width = 0
  @taken_by_title = 0
  @title_lines = []
  @user = nil

  def self.board(user, board)
    @user = user
    reset_board board
    while true
      draw_board board
      return if handle_input board
    end
  end

  private

  def self.reset_board board
    @entries = Fileops.get_board_entries(board)
    @width  = 0
    @height = 0
    # arbitary dimensions
    @scroll_select = ScrollSelect.new @entries, method(:activate_board), 0, 10
  end


  def self.draw_board(board)
    Screen.clear

    width = Screen.width
    if width != @width
      @width = width
      setup_title board
    end

    height = Screen.height
    if height != @height
      @height = height
      @scroll_select.new_start_row @title_lines.count + 1
      @scroll_select.new_height height - @title_lines.count - 1 
    end

    print_title
   
    if @entries.empty?
      puts "Tahle nástěnka je prázdná jak moje peněženka. " \
         + "Co takhle to napravit?"
             end

    print_help_bar

    @scroll_select.draw
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


  def self.activate_board(entry)
    EntryDisplay.entry_display @user, entry
  end


  def self.handle_input(board)
    ch = Screen.getch
    case ch
    when "q"
      return true

    when "\x03"
      exit 0

    when "h"
      Help.post_help

    when "n"
      Messages.new_entry @user, board
      reset_board board

    when "\r" # return is \r, which makes sense I quess...
      @scroll_select.select

    when "\e"
      ScrollControll.scroll_controll @scroll_select
    end
    return false
  end
end
