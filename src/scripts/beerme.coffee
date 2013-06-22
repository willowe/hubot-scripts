# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   beer me - Grab me a beer
#
# Author:
#  houndbee

beers = [
  "http://organicxbenefits.com/wp-content/uploads/2011/11/organic-beer-health-benefits.jpg",
  "http://www.beer100.com/images/beermug.jpg",
  "http://www.joyandfood.com/wp-content/uploads/2012/05/Beer-beer.jpg",
  "http://www.bristolvantage.com/wp-content/uploads/2012/02/beer-calories1.jpg",
  "http://cdn.biruwananbai.com/wp-content/uploads/2012/04/more_beer-01.jpg",
  "http://blog.collegebars.net/uploads/10-beers-you-must-drink-this-summer/10-beers-you-must-drink-this-summer-sam-adams-summer-ale.jpg"
  "http://media.treehugger.com/assets/images/2011/10/save-the-beers.jpg",
  "http://poemsforkush.files.wordpress.com/2012/04/beer.jpg",
  "http://www.wirtzbeveragegroup.com/wirtzbeveragenevada/wp-content/uploads/2010/06/Beer.jpg",
  "http://www.walyou.com/blog/wp-content/uploads/2010/06/giant-beer-glass-fathers-day-beer-gadgets-2010.jpg",
  "http://images.free-extras.com/pics/f/free_beer-911.jpg",
  "http://images.seroundtable.com/android-beer-dispenser-1335181876.jpg",
  "http://www.mediabistro.com/fishbowlDC/files/original/beer-will-change-the-world.jpg",
  "http://dribbble.s3.amazonaws.com/users/79978/screenshots/594281/attachments/47191/more.png",
  "http://www.gqindia.com/sites/default/files/imagecache/article-inner-image-341-354/article/slideshow/1289/beer.JPG",
  "http://www.gqindia.com/sites/default/files/imagecache/article-inner-image-341-354/article/slideshow/1289/beer2.jpg",
  "http://www.gqindia.com/sites/default/files/imagecache/article-inner-image-341-354/article/slideshow/1289/Beer3.jpg",
  "http://www.x-hellenica.gr/KioskImages/48/2_Mythos_lager_bottle_500ml.jpg",
  "http://3.bp.blogspot.com/-KTzOW3S-I5U/TxMDcf-LWQI/AAAAAAAAALE/NZBLLBT66PI/s1600/beer+4.jpg",
  "http://files.coloribus.com/files/adsarchive/part_353/3537855/file/malzbier-dark-beer-black-power-small-78000.jpg",
  "http://www.merchantduvin.com/images/i-lindemans-lambic-family.jpg",
  "http://craftbeeracademy.com/wp-content/uploads/2012/11/istock_stout_line.jpeg"
]

module.exports = (robot) ->
  robot.hear /.*(beer me).*/i, (msg) ->
    msg.send msg.random beers
