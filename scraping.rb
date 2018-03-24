require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'




#rails g scaffold Post name body:text image url sources video cover state:boolean category:references

=begin
url = 'http://www.reactiongifs.com/'
5.times do |i|
  puts "Página #{i}"
  document = Nokogiri::HTML(open(url))
  div_main = document.css('div#main')
  div_main.css('div.post').each do |post|
    title = post.css('h2').text
    gif_url = post.css('div.entry img').attr('src')
    File.open("gifs/#{title}.gif", 'w') do |new_file|
      puts "Descargando gif: #{title}"
      open(gif_url, 'r') do |gif|
        new_file.write(gif.read)
      end
    end
  end
  url = document.css('div.nav-entries div.nav-next a').attr('href')
end


url = 'https://www.las2orillas.co/'
document = Nokogiri::HTML(open(url))
div_main = document.css('div#content') #id del div
div_inmain = div_main.css('div#main-masonry')
div_inmain.css('div.box-masonry-main').each do |post| #class del div
    name = post.css('h4').text
    body = post.css('div.entry-content').text
    image = post.css('div.widget-post-big-thumb img').attr('src')
    url = document.css('h4.entry-title a').attr('href')
    sources = url
    #video 
    cover = post.css('div.widget-post-big-thumb img').attr('src')
    state = true
    category = "politica"
    @posts = sources
end
puts '------------------------------------------'
puts @posts
puts url
puts '------------------------------------------'
puts 'INGRESO A LA URL DEL POST'

document = Nokogiri::HTML(open(url))
div_main = document.css('div#entry-post') 
div_inmain = div_main.css('article')
puts '------------------------------------------'
puts div_inmain
puts '------------------------------------------'
=end
#https://www.elmanana.com


##SCRAPING LINK SEMANA https://vepeliculas.tv/
=begin
url = 'https://vepeliculas.tv/'
document = Nokogiri::HTML(open(url))
div_main = document.css('div.tray-content')
div_main.css('div.tray-item').each do |post|
  contect = post.css('div.tray-item-content')
  link_con = post.css('div.tray-item-content').css('a').attr('href')
  img_con = post.css('div.tray-item-content').css('img').attr('src')
  name_con = post.css('div.tray-item-content').css('div.tray-item-description').css('div.tray-item-title').css('a').text
  con2 = post.css('div.tray-item-content').css('div.tray-item-play').css('a').attr('data-content')
  #category_con = con2
  #body_con = con2
  
  #https://vepeliculas.tv/ajax.php?time=1521648122294
  #https://vepeliculas.tv/ajax.php?time=1521648614
  #post_url = "https://vepeliculas.tv/ajax.php?time=#{Time.now().strftime('%s')}&Ajax_Episode=true&movieid=oc60w&action=episode_get&episode=1&User_Login=false&userIp=190.146.222.32"
  #option = "Ajax_Episode=true&movieid=oc60w&action=episode_get&episode=1&User_Login=false&userIp=190.146.222.32"
  #res = Net::HTTP.post_form(post_url)
  #uri = URI(link_con)
  #puts Net::HTTP.get(uri)

  puts '------------------------'
end
=end
url = 'http://www.planetatvonlinehd.com/'
document = Nokogiri::HTML(open(url))
div_main = document.css('main div.ed-item section.box')
div_main.css('div.homelist').each do |post|
  name = post.css('a').text
  url_video = post.css('a').attr('href')
  document = Nokogiri::HTML(open(url_video))
  imagen = document.css('section.container main.ed-item article.single section.single__content').css('img').attr('src')
  body = document.css('section.container main.ed-item article.single section.single__content').css('p').text
  sources = url
  video = nil
  document.css('section.container main.ed-item article.single section.single__content div.tabs div.tab').each do |item|
    if item.css('div.content').to_s.include?('iframe')
      video = item.css('div.content').css('iframe').attr('src')
    else
      
    end
  end
  
  puts video
  puts '*************************'
end