require_relative 'screen'
require_relative 'scroll_controll'

# TODO: make help screen scroll
module Help
@post_help = '
Pokud příspěvek (nikoli však prozpěvek) je začátkem nového vlákna, tudíž není
odpovědí (logickou, Klobouk neumí číst tvé myšlenky!), je jeho první řádek brán
jako nadpis nového vlákna.
V textu zprávy však bude zachován.

Jelikož se text následně zpracovává pro různá rozlišení, můžeme si dovolit pár
kulišáren.
Podobně jako v Markdownu, odstavce se dělí dvěmi novými řádky (\n\n)
a zapomoci tří "zpětných klíšťat" na vlastním řádku (```) (AltGr+;) se dá
přepínat do "kódového módu", kde se žádné kulišárny neprovádějí.

Jako editor se používá dialog(1).
Pro smazání prázdného řádku použijte <Ctrl-Backspace>.

Více markdown funkcí zde však nečekejte, neb jsem línej jak /\w*?/.

Nechť tě provází Klobouk!
'


  def self.post_help
    display @post_help
  end

  private

  def self.display(text)
    @height = Screen.height
    @scroll_view = ScrollView.new text, 0, @height
    while true
      draw
      return if handle_input
    end
  end


  def self.draw
    Screen.clear
    height = Screen.height
    if height != @height
      @height = height
      @scroll_view.new_height height
    end

    @scroll_view.draw
  end


  def self.handle_input
    ch = Screen.getch
    case ch
    when "\x03"
      STDIN.echo = true
      exit 0
      
    when "\e"
      ScrollControll.scroll_controll @scroll_view

    else
      return true
    end
    return false
  end
end
