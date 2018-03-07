
require 'nokogiri'
require 'open-uri'

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


##SCRAPING LINK SEMANA
url = 'http://www.semana.com/confidenciales/articulo/amazon-llego-a-colombia/558968'

  document = Nokogiri::HTML(open(url))
  div_main = document.css('div.off-canvas-wrap')
  div_main2 = div_main.css('section#ppalSeccionHome')
  div_main3 = div_main2.css('div.row')
  div_main4 = div_main3.css('div.small-12')
  div_main5 = div_main4.css('article.article')
  titulo = div_main5.css('h2.article-h').text
  gif_url = div_main5.css('a.related-news-th img').attr('src')
  File.open("#{titulo}.jpg", 'w') do |new_file|
    puts "Descargando gif: #{titulo}"
    open(gif_url, 'r') do |gif|
      new_file.write(gif.read)
    end
  end
  cuerpo = div_main5.css('p').text

  puts titulo 
  puts cuerpo  