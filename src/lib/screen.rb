require 'io/console'

module Screen
  def self.width
    STDIN.winsize[1]
  end


  def self.height
    STDIN.winsize[0]
  end


  def self.clear
    print "\ec"
  end


  def self.getch
    STDIN.echo = false
    STDIN.getch
  end


  def self.center(txt)
    pad = (width - txt.length) / 2 
    pad = 0 if pad < 0
    " "*pad + txt 
  end

  
  def self.parse_text(txt)
    max_width = width
    lines = []
    line = " " # begin paragraph with indend
    pre = false

    # lambdas, because I need the variables in cloures

    handle_word = -> (word){
      if word.length > max_width
        #                ↓ also count in added space
        bar = max_width -2- line.length
        # what fits                     
        handle_word.call word[(..bar)]
        # rest
        handle_word.call word[(bar+1..)]
      else

        if line.length + word.length + 1 <= max_width
          line += " " unless line.empty?
          line += word
        else
          lines << line
          line = word
          current_width = word.length
        end
      end
    }

    handle_pre_line = -> (ln){
      if ln.length > max_width
        handle_pre_line.call ln[(..max_width-1)]
        handle_pre_line.call ln[(max_width..)]
      else
        lines << ln
      end
    }

    txt.split(/^```$/).each {|block|
      unless pre
        block.split(/\n{2,}/).each{|par|
          par.split.each {|word| handle_word.call word}
          lines << line
            line = " "
        }
      else
        block.split("\n").each {|ln| handle_pre_line.call ln}
      end
      pre = !pre
    }

    return lines
  end
end
