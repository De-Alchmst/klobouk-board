require_relative 'screen'
require_relative 'entry_handle'
require_relative 'scroll_view'
require_relative 'help'
require_relative 'scroll_controll'

module EntryDisplay
  HELP_BAR_TEXT = \
    "Pomoc (h) | Odpověď (n) | Posunout (↑↓) | Odejít (q)"


  def self.entry_display(board, posts)
    @height = Screen.height
    @scroll_view = ScrollView.new "", 0, @height - 1
    prepare_post_text posts
    while true
      draw_entry
      return if handle_input board, posts
    end
  end

  private

  def self.draw_entry
    Screen.clear
    height = Screen.height
    if height != @height
      @height = height
      @scroll_view.new_height height
    end

    @scroll_view.draw
    print_help_bar
  end
  

  def self.print_help_bar
    print "\e[#{Screen.height};0H#{HELP_BAR_TEXT[(..Screen.width-1)]}"
  end


  def self.prepare_post_text(posts)
    text = ""
    for i in (0..posts.count-1)
      post = posts[i]
      text += "\n```\n===================\n#{i} : #{post["author"]} : " + \
              "#{post["time"]}\n\n#{post["contents"]}\n```\n"
    end
    @scroll_view.new_text text.strip
  end


  def self.handle_input(board, posts)
    ch = Screen.getch
    case ch
    when "q"
      return true

    when "\x03"
      exit 0

    when "h"
      Help.post_help
      
    when "\e"
      ScrollControll.scroll_controll @scroll_view
    end
    return false
  end
end
