require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'
require 'json'



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
        if item.css('div.content div.video').text.include?("loadopen")
          codigo = item.css('div.content div.video').css('div.video').css('script').text.delete('loadopen').delete('("').delete('")')
          video = "https://openload.co/embed/#{codigo.to_s}/"
          puts video
        else
          codigo = item.css('div.content div.video').css('div.video').css('script').text.delete('mango').delete('("').delete('")')
          video = "https://streamango.com/embed/#{codigo.to_s}/"
          puts video
        end
    end
  end
  
  puts video
  puts '*************************'
end






#auteur = "comte de Flandre et Hainaut, Baudouin, Jacques, Thierry"
#auteur = '{"es": "https://openload.co/embed/70iw8Ftq4pw/M.4.Z.3%2FR.U.N.N.3.R%2F3%2FT.H.3%2FD.3.4.T.H%2FC.U.R.3.mp4", "es_la": "https://openload.co/embed/MHB_8RoMtwY/M.4.Z.3%2FR.U.N.N.3.R%2F3%2FT.H.3%2FD.3.4.T.H%2FC.U.R.3.mp4", "vose": "https://openload.co/embed/LwAU9PityOk/M.4.Z.3%2FR.U.N.N.3.R%2F3%2FT.H.3%2FD.3.4.T.H%2FC.U.R.3.mp4", "en": "" } = "http://www.cliver.tv/img/peliculas/portadas/2789_80975.jpg" = "2789";'
#nom = auteur.gsub(/.*}/, '')
#puts nom


url = 'http://www.cliver.tv/'
document = Nokogiri::HTML(open(url))
div_main = document.css('div.contenedor div.int-cont section.panel-der')
div_main.css('div.contenidos-p article.contenido-p').each do |post|
  puts post.css('div.portada-p').css('a img')
  puts '------------------------'
  puts post.css('div.portada-p').css('a').attr('href')
  puts '------------------------'
  puts post.css('div.titulo-p').css('a h2').text
  puts '------------------------'
  url = post.css('div.portada-p').css('a').attr('href')
  document = Nokogiri::HTML(open(url))
  cont = document.css('script')#css('div.contenedor div.int-cont section.peli-izq').xpath('uVXUkRb4GQ')
  contador = 0
  cont.each do |script|
    if script.to_s.include?('openload') && contador == 0
      object = script.text.to_s.gsub(/.*var urlVideos = /, '').partition(";")[0]
      videos = JSON.parse(object.to_s)
      puts !videos['es'].eql?('') ? "SI ES #{videos['es']}" : !videos['es_la'].eql?('') ? "SI ES_LA #{videos['es_la']}" : "SI VOSE #{videos['vose']}"
      contador = +1
    end
  end  
  #sleep 1
  url = nil
  puts '************************'
end











url = 'http://tv-vip.com/film/Coco.mp4/'
sub = ["so", "kt", "ku", "hs"]
document = Nokogiri::HTML(open(url))
div_main = document.css('body')
name = url.gsub('http://tv-vip.com/film/', '').gsub('/', '')
puts '------------------------'  
sub.each do |sub|
  puts "http://#{sub}.tv-vip.info/c/transcoder/#{name}/360-mp4/#{name}.mp4?tt=0&mm=0&bb=0"
end
puts '------------------------'

=end


url = 'http://tv-vip.com/section/accion/'
document = Nokogiri::HTML(open(url))
div_main = document.css('body')#.css('')
puts div_main


