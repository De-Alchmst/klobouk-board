require 'io/console'

module Screen
  def self.getWidth
    80
  end


  def self.getHeight
    23
  end


  def self.clear
    print "\ec"
  end


  def self.getch
    STDIN.echo = false
    STDIN.getch
  end
end
