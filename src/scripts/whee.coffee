# Description:
#   What to play when someone says "whee!"
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   whee
#
# Author:
#   Richard Yen

module.exports = (robot) ->
  robot.hear /whee/i, (msg) ->
    msg.send "http://www.youtube.com/watch?v=Q9G4qaOD2Bo"
