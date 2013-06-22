# Description:
#   Notifies you via Hubot when WebsitePulse thinks you have a problem.
#
# Dependencies:
#   scoped-http-client
#
# Configuration:
#   HUBOT_WEBSITEPULSE_URL
#   HUBOT_WEBSITEPULSE_USER
#   HUBOT_WEBSITEPULSE_KEY 
#   HUBOT_WEBSITEPULSE_PATTERN
#
# Commands:
#   wsp (pattern) -- show WSP problematic WSP targets matching pattern
#
# Notes:
#    Copywrite 2013 iParadigms LLC.   
#    Redistributable under the same license as used by the rest of hubot-scripts at https://github.com/github/hubot-scripts/blob/master/LICENSE.
#
# Author:
#   willowe

HttpClient = require "scoped-http-client"

module.exports = (robot) ->

# TODO:
# * allow showing targets which aren't failed (need new command syntax probably)
# * fetch the default "last 2 hours" chart for a given target

  wsp_url  = process.env.HUBOT_WEBSITEPULSE_URL || "http://api.websitepulse.com/textserver.php"
  wsp_user = process.env.HUBOT_WEBSITEPULSE_USER || false
  wsp_key  = process.env.HUBOT_WEBSITEPULSE_KEY || false
  wsp_room = process.env.HUBOT_WEBSITEPULSE_ROOM || false
  default_search_pattern = process.env.HUBOT_WEBSITEPULSE_PATTERN || ".*"

  wsp_cache = []
  wsp_last_fetch = false
  refresh_timer = false

  parse_wsp = ( text ) ->
     new_wsp = []
     lines = text.split /\n/

     for l in lines
         if not l.match /^\s*$/ 
            parts = for p in l.split /\t/
               (p.split /\"/)[1]
            parts[1] = (parts[1].split /\s*,/)[0]
            new_wsp.push parts

     wsp_cache = new_wsp
     wsp_last_fetch = new Date()

     robot.logger.debug( "cached #{wsp_cache.length} WSP targets" )

  update_wsp_cache = ( action, one_time_only ) ->

     clearTimeout( refresh_timer ) if refresh_timer and not one_time_only

     the_url = "#{wsp_url}?username=#{wsp_user}&key=#{wsp_key}&method=GetStatus&format=txt&target=all&location=all"     

     robot.logger.debug "updating WSP cache"

     HttpClient.create(the_url).get() (err,res, body) -> 

        if wsp_room and not one_time_only
          refresh_timer = setTimeout( update_wsp_cache, 900000, action )

        robot.logger.debug "read #{body.length} bytes of data from WSP"
        if body.match(/^(Error|Invalid)/)
          robot.logger.info "WSP fetch failed: #{body}"
          return []
        parse_wsp( body )
        action()

  do_wsp = (msg, action) ->
     currentDate = new Date()

     # if we've fetched in the last 5m use the cache
     if wsp_last_fetch and wsp_last_fetch > (currentDate.getTime() - (1000 * 60 * 5))
        msg.reply "using cached WSP data from #{wsp_last_fetch.toString()}"
        action()
        return 

     msg.reply "hang on,  fetching WSP data (might take 1-2m)"

     update_wsp_cache( action, true )

  display_wsp_problems = ( pattern, silent_on_all_clear, output ) ->

    problems = []
  
    for l in wsp_cache
        if ((not pattern) or l[0].match(pattern)) and ( l[5] != "OK" and not l[5].match(/^Checking/) )
           problems.push "#{l[0]} (#{l[2]} from #{l[1]}): #{l[5]}"

    robot.logger.debug "found #{problems.length} WSP problems to display"

    if problems.length == 0
       if not silent_on_all_clear
          output "WSP ALL CLEAR"
    else
       output "WSP detected #{problems.length} problems matching #{pattern}:\n-------------------------------------------\n" + problems.sort().reverse().join("\n")

  robot.respond /wsp\s*([^s]*)/i, (msg) ->

    if not wsp_user
       robot.logger.info "websitepulse not configured (missing HUBOT_WEBSITEPULSE_USER)"
       msg.reply "WSP not configured.  Set HUBOT_WEBSITEPULSE_USER or remove websitepulse.coffee."
       return

    if not wsp_key
       robot.logger.info "websitepulse not configured (missing HUBOT_WEBSITEPULSE_KEY)"
       msg.reply "WSP not configured.  Set HUBOT_WEBSITEPULSE_KEY or remove websitepulse.coffee."
       return

    pattern = msg.match[1] || default_search_pattern

    do_wsp msg, () ->
      display_wsp_problems pattern, false, (txt) ->
        msg.reply txt

    return
          
  if wsp_room
    action = () -> 
        display_wsp_problems default_search_pattern, true, (txt) ->
          robot.messageRoom wsp_room, txt
    refresh_timer = setTimeout( update_wsp_cache, 900000, action, false )

