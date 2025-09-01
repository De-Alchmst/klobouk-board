#! /usr/bin/env ruby
require_relative 'lib/login'
require_relative 'lib/index'

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


# user = Login.login
# Index.index user
Index.index 'de-alchmst'

puts '
###################
## Vrať se brzy! ##
###################
'
