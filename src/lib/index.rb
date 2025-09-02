require_relative 'fileops'
require_relative 'screen'
require_relative 'user_config'
require_relative 'board'
require_relative 'scroll_view'

module Index
  @boards_data = Fileops.get_boards
  @scroll_view = ScrollView.new "", 0, Screen.height
  @exit = false

  def self.index(user)
    @scroll_view.new_text gather_contents
    while true
      draw_index
      return if handle_input user
    end
  end

  private

  def self.gather_contents
    text ="```
Uživatel:
  Odejít (q)
  Nastavení účtu (u)

She-Mail: <zatím neimplementováno>
  Schránka (s)
  Nová zpráva (z) 

Nástěnky:
" + list_boards + "\n```"
  end

  # TODO: draw_index manage screen size
  def self.draw_index
    Screen.clear
    height = Screen.height
    if height != @height
      @height = height
      @scroll_view.new_height height
    end

    @scroll_view.draw
  end


  def self.list_boards
    return @boards_data.map {|board|
      "  /#{board["name"]}/ (#{board["key"]})"
    }.join "\n"
  end


  def self.handle_input(user)
    ch = Screen.getch
    case ch
    when 'q'
      return true

    when "\x03" # ^C
      exit 0

    when 'u'
      UserConfig.user_config user

    when '\e'
      ScrollControll.scroll_controll @scroll_view
    end

    @boards_data.each {|board|
      if ch == board["key"]
        Board.board user, board
      end
    }

    return false
  end
end
