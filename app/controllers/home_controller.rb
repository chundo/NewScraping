class HomeController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  def index
    @posts = Post.where(state: true)
    @covers = Cover.where(status: true).limit(5)
  end

  def noticias
    @posts = Post.where(state: true)
  end

  def noticia
    @post =  Post.friendly.find(params[:id])
  end

  def categoria 
    @category =  Category.friendly.find(params[:id])
  end

  def scraping
    
    if params['url']
      puts 'Url a hacer scraping'
    end
    
    if params['url'] and params['url'].eql?('https://vepeliculas.tv/') #solo si url es igual a https://vepeliculas.tv/
      url = 'https://vepeliculas.tv/'
      document = Nokogiri::HTML(open(url))
      div_main = document.css('div.tray-content')
      div_main.css('div.tray-item').each do |post|
        contect = post.css('div.tray-item-content')
        link_con = post.css('div.tray-item-content').css('a').attr('href')
        img_con = post.css('div.tray-item-content').css('img').attr('src')
        name_con = post.css('div.tray-item-content').css('div.tray-item-description').css('div.tray-item-title').css('a').text
        con2 = post.css('div.tray-item-content').css('div.tray-item-play').css('a').attr('data-content')
        video = Nokogiri::HTML(open(link_con))
        category_con = con2
        body_con = con2
        Post.create(name: name_con, url: link_con, image: img_con, body: 'pendiente', sources: 'pendiente', state: true )
      end
    elsif params['url'] and params['url'].eql?('http://www.planetatvonlinehd.com/') #solo si url es igual a https://vepeliculas.tv/
      url = 'http://www.planetatvonlinehd.com/'
      document = Nokogiri::HTML(open(url))
      div_main = document.css('main div.ed-item section.box')
      div_main.css('div.homelist').each do |post|
        name = post.css('a').text
        link_con = post.css('a').attr('href')
        document = Nokogiri::HTML(open(link_con))
        imagen = document.css('section.container main.ed-item article.single section.single__content').css('img').attr('src')
        body = document.css('section.container main.ed-item article.single section.single__content').css('p').text
        sources = url
        video = nil
        state = nil
        document.css('section.container main.ed-item article.single section.single__content div.tabs div.tab').each do |item|
          state = item.css('div.content').to_s.include?('iframe')
          if item.css('div.content').to_s.include?('iframe')
            video = item.css('div.content').css('iframe').attr('src')
          else
            
          end
          Post.create(name: name, url: link_con, image: imagen, body: body, sources: sources, state: state, video: video )
        end
        puts '*************************'
      end
    end

  end
end
