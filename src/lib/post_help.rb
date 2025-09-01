require_relative 'screen'

# TODO: make help screen scroll
module PostHelp
@help = '
Pokud příspěvek (nikoli však prozpěvek) je začátkem nového vlákna, tudíž není
odpovědí (logickou, Klobouk neumí číst tvé myšlenky!), je jeho první řádek brán
jako nadpis nového vlákna.
V textu zprávy však bude zachován.

Jelikož se text následně zpracovává pro různá rozlišení, můžeme si dovolit pár
kulišáren.
Podobně jako v Markdownu, odstavce se dělí dvěmi novými řádky (\n\n)
a zapomoci tří "zpětných klíšťat" na vlastním řádku (```) (AltGr+;) se dá
přepínat do "kódového módu", kde se žádné kulišárny neprovádějí.

Více markdown funkcí zde však nečekejte, neb jsem línej jak /\w*?/.

Nechť tě provází Klobouk!
'

  def self.post_help
    Screen.clear
    puts Screen.parse_text(@help).join "\n"
    Screen.getch
  end
end
