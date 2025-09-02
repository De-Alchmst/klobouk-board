require_relative 'screen'

# Options are hashes with a ["title"] field
# selected options are given to @activator

class ScrollSelect
  def initialize(options, activator, start_row, height)
    @options   = options
    @activator = activator
    @start_row = start_row
    @height    = height

    @width     = Screen.width
    @pointer   = 0
    @scroll    = 0

    parse_option_titles
  end


  def draw
    if @width != Screen.width
      @width = Screen.width
      parse_option_titles
    end

    print "\e[#{@start_row};0H"
    for i in (@scroll..[@scroll+@height-1, @options_titles.count-1].min)
      if i == @pointer
        puts "\e[7m#{@options_titles[i]}\e[27m"
      else
        puts @options_titles[i]
      end
    end
  end


  def down # increment
    return if @pointer == @options.count-1

    @pointer += 1
    @scroll  += 1 if @pointer >= @scroll+@height
  end


  def up # decrement
    return if @pointer == 0

    @pointer -= 1
    @scroll  -= 1 if @pointer < @scroll
  end


  def bottom
    @pointer = @options.count-1
    @scroll = @options.count - @height if @options.count > @height
  end


  def top
    @pointer = 0
    @scroll = 0
  end


  def select
    @activator.call @options[@pointer]
  end


  def new_height(height)
    @height = height
    @scroll = @pointer           if @pointer < @scroll
    @scroll = @pointer-@height+1 if @pointer >= @scroll+@height
  end


  def new_start_row(start_row)
    @start_row = start_row
  end


  def new_options(options)
    @pointer = 0
    @scroll  = 0
    parse_option_titles
  end

  private
  
  def parse_option_titles
    width = @width-1
    @options_titles = @options.map {|opt|
      title = opt["title"][(..width)]
      # add full padding for proper reverse rendering
      # it's not the only thing that breaks with widechars...
      # hence '.sanitize'
      title 
    }
  end

end
