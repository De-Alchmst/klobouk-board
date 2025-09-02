require_relative 'screen'
require_relative 'messages'
require_relative 'scroll_view'
require_relative 'help'
require_relative 'scroll_controll'

module EntryDisplay
  HELP_BAR_TEXT = \
    "Pomoc (h) | Odpověď (n) | Posunout (↑↓) | Odejít (q)"


  def self.entry_display(user, entry)
    @height = Screen.height
    @scroll_view = ScrollView.new "", 0, @height - 1
    prepare_post_text entry
    while true
      draw_entry
      return if handle_input user, entry
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


  def self.prepare_post_text(entry)
    posts = Fileops.get_entry_posts(entry)
    text = ""
    for i in (0..posts.count-1)
      post = posts[i]
      text += "\n```\n===================\n#{i} : #{post["author"]} : " + \
              "#{post["time"]}\n\n#{post["contents"]}\n```\n"
    end
    @scroll_view.new_text text.strip
  end


  def self.handle_input(user, entry)
    ch = Screen.getch
    case ch
    when "q"
      return true

    when "\x03"
      STDIN.echo = true
      exit 0

    when "h"
      Help.post_help

    when "n"
      Messages.new_reply user, entry
      prepare_post_text entry
      
    when "\e"
      ScrollControll.scroll_controll @scroll_view
    end
    return false
  end
end
