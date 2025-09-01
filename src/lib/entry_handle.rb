require "tempfile"

require_relative 'fileops'
require_relative 'screen'

module EntryHandle
  def self.write_new(user, board)
    contents = edit ""
    return if contents.empty? # <cancel>
  end

  private

  def self.edit txt
    file = Tempfile.new('klobouk_dialog_out')
    file.write txt
    Screen.clear
    # TERM=vt100 disables colors
    #            colored dialog can look weird with the same colorscheme for
    #            both darktheme and lighttheme users
    # -- topleft fixes alignment with smaller clients
    #            dialog does not see terminal dimensions, so it always thinks
    #            the terminal is 80x24
    system("TERM=vt100 ; dialog --topleft --editbox " +\
           "#{file.path} #{Screen.height} #{Screen.width} 2> #{file.path}")
    file.rewind # rewind back to beninging after writing
    result = file.read.strip
    file.close
    file.unlink
    return result
  end
end
