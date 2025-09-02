require_relative 'fileops'
require_relative 'screen'
require_relative 'post_help'
require_relative 'entry_handle'
require_relative 'scroll_select'
require_relative 'entry_display'

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
    EntryDisplay.entry_display entry, Fileops.get_entry_posts(entry)
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

    when "\r" # return is \r, which makes sense I quess...
      @scroll_select.select

    # arrow keys are composite
    # "\e[A/B/C/D"
    when "\e"
      STDIN.getch # [
      case STDIN.getch
      when "A"
        @scroll_select.up
      when "B"
        @scroll_select.down

      # home/end
      # "\e[HF"
      when "H"
        @scroll_select.top
      when "F"
        @scroll_select.bottom

      # page up and down
      # "\e[5/6~"
      when "5"
        10.times { @scroll_select.up }
        STDIN.getch
      when "6"
        10.times { @scroll_select.down }
        STDIN.getch
      end
    end
    return false
  end
end
