class HomeController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  def index
    @posts = Post.where(state: true)
  end

  def noticias
    @posts = Post.where(state: true)
  end

  def noticia
    @post =  Post.find(params[:id])
  end

  def scraping
    
    if params['url'] 
      url = params['url'] #'http://www.reactiongifs.com/'
      1.times do |i|
        puts "Página #{i}"
        document = Nokogiri::HTML(open(url))
        div_main = document.css('div#main')
        div_main.css('div.post').each do |post|
          title = post.css('h2').text
          gif_url = post.css('div.entry img').attr('src')
          #File.open(%"./public/imagens/#{title}.gif", 'w') do |new_file|
            #puts "Descargando gif: #{title}"
            #open(gif_url, 'r') do |gif|
            #  new_file.write(gif.read)
            #end
          #end
        end
        url = document.css('div.nav-entries div.nav-next a').attr('href')
      end
    end
  end
end
