require_relative 'screen'

class ScrollView
  def initialize(text, start_row, height)
    @text = text
    @start_row = start_row
    @height    = height

    @width     = Screen.width
    @pointer   = 0
    @scroll    = 0

    parse_text
  end


  def draw
    if @width != Screen.width
      @width = Screen.width
      parse_text
    end

    print "\e[#{@start_row};0H"
    for i in (@scroll..[@scroll+@height-1, @lines.count-1].min)
      puts @lines[i]
    end

  end


  def down # increment
    @scroll += 1 if @lines.count - @scroll > @height
  end


  def up # decrement
    @scroll -= 1 if @scroll > 0
  end


  def bottom
    @scroll = @lines.count - @height if @lines.count > @height
  end

  def top
    @scroll = 0
  end
  

  def new_height(height)
    @height = height
  end


  def new_start_row(start_row)
    @start_row = start_row
  end


  def new_text(text)
    @text = text
    parse_text
  end

  private

  def parse_text
    @lines = Screen.parse_text @text
  end
end
