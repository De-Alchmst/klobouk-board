module ScrollControll
  def self.scroll_controll(scroller)
    # arrow keys are composite
    # "\e[A/B/C/D"
    STDIN.getch # [
    case STDIN.getch
    when "A"
      scroller.up
    when "B"
      scroller.down

    # home/end
    # "\e[HF"
    when "H"
      scroller.top
    when "F"
      scroller.bottom
    
    # page up and down
    # "\e[5/6~"
    when "5"
      10.times { scroller.up }
      STDIN.getch
    when "6"
      10.times { scroller.down }
      STDIN.getch
    end
  end
end
