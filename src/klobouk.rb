#! /usr/bin/env ruby
require_relative 'lib/login'
require_relative 'lib/index'

DEBUG = ARGV[0] == "debug"

HERE = File.dirname __FILE__


puts '
         #######################
         ## Vítej v Klobouku! ##
         #######################

           _.---._
          /       \__.-----._ 
         |                   \
         |                    \
         |                    |
         |                    |
 _______/                      \_____________._.
/____________________________________________OwO

'

unless DEBUG
  user = Login.login
  Index.index user
else
  #Index.index 'de-alchmst'
  require_relative 'lib/post_help'
  PostHelp.post_help
end

puts '
###################
## Vrať se brzy! ##
###################
'
