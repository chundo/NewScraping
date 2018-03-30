class HomeController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'graphql'
  require 'json'

  before_action :covers_header

  def index
    @posts = Post.where(state: true).limit(60)
    @covers = Cover.where(status: true).limit(5)
    @post_tag = Post.where('created_at >= :uno and state == :dos', :uno  => Time.now - 25.days, :dos => true).limit(4).order(views: :desc)
    @posts_top = Post.where('created_at >= :uno and state == :dos', :uno  => Time.now - 15.days, :dos => true).limit(10).order(views: :desc)
  end

  def noticias
    @posts = Post.where(state: true).limit(60)
  end

  def noticia
    response.set_header('HEADER NAME', 'HEADER VALUE')
    @post =  Post.friendly.find(params[:id])    
    @post.update(views: @post.views + 1)
  end

  def categoria 
    @category =  Category.friendly.find(params[:id])
  end

  def buscar
    @posts = Post.where("name LIKE ?", "%#{params[:q]}%")
    render 'buscar'
  end

  def videos
    @posts = Post.where("name LIKE ? or body LIKE ? ", "%#{params[:id]}%", "%#{params[:id]}%")
    render 'buscar'
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
        imagen = post.css('div.tray-item-content').css('img').attr('src')
        name = post.css('div.tray-item-content').css('div.tray-item-description').css('div.tray-item-title').css('a').text
        con2 = post.css('div.tray-item-content').css('div.tray-item-play').css('a').attr('data-content')
        video = Nokogiri::HTML(open(link_con))
        category_con = con2
        body_con = con2
        Post.create(name: name_con, url: link_con, image: img_con, body: 'pendiente', sources: 'pendiente', state: true )
      end
    elsif params['url'] and params['url'].include?('http://www.planetatvonlinehd.com/') #OK
      url = params['url']#'http://www.planetatvonlinehd.com/'
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
        #@videos = Array.new 
        document.css('section.container main.ed-item article.single section.single__content div.tabs div.tab').each do |item|
          state = item.css('div.content').to_s.include?('iframe') and !imagen.nil?
          if item.css('div.content').to_s.include?('iframe')
            video = item.css('div.content').css('iframe').attr('src')
            #@videos.insert({"url": video })
          else
            if item.css('div.content div.video').text.include?("loadopen")
              state = item.css('div.content div.video').css('div.video').to_s.include?('script') and !imagen.nil?
              codigo = item.css('div.content div.video').css('div.video').to_s[38..-19]#.css('script').text.delete('loadopen')#.delete('(').delete(')').delete('"').delete('"')
              puts item.css('div.content div.video').css('div.video').css('script')
              video = "https://openload.co/embed/#{codigo.to_s}/"
              #@videos.insert({"url": video })
            end
          end
          #video = '[{"url": "https://streamango.com/embed/rqfskrffrsss/"}, {"url": "https://streamango.com/embed/rqfskrffrsss/"}]'
         Post.create_scraping(name, link_con, state, imagen, body, video, sources)
        end
        puts '*************************'
      end
    elsif params['url'] and params['url'].eql?('http://www.cliver.tv/') #solo si url es igual a https://vepeliculas.tv/
      
      url = 'http://www.cliver.tv/'
      document = Nokogiri::HTML(open(url))
      div_main = document.css('div.contenedor div.int-cont section.panel-der')
      div_main.css('div.contenidos-p article.contenido-p').each do |post|
        imagen = post.css('div.portada-p').css('a img').attr('src')
        puts '------------------------'
        link_con = post.css('div.portada-p').css('a').attr('href')
        puts '------------------------'
        name = post.css('div.titulo-p').css('a h2').text
        puts '------------------------'
        url = post.css('div.portada-p').css('a').attr('href')
        document = Nokogiri::HTML(open(url))
        cont = document.css('script')#css('div.contenedor div.int-cont section.peli-izq').xpath('uVXUkRb4GQ')
        contador = 0
        sources = url
        video = nil
        body = 'sssss'
        cont.each do |script|
          if script.to_s.include?('openload') && contador == 0
            object = script.text.to_s.gsub(/.*var urlVideos = /, '').partition(";")[0]
            videos = JSON.parse(object.to_s)
            video = !videos['es'].eql?('') ? videos['es'] : !videos['es_la'].eql?('') ? videos['es_la'] : videos['vose']
            contador = +1
          end
        end  
        state = !video.nil? and !imagen.nil?
        
        Post.create_scraping(name, link_con, state, imagen, body, video, sources)
        url = nil
        puts '************************'
      end

    end
  end

  def test
    @post = Post.find_by(url: '')
  end

  private
  def covers_header
    @covers = Cover.where(status: true).limit(5)
  end

  def crete_scraping
    post = Post.find_by(url: link_con.to_s)
    if !post.nil?
      if state
        post.update(image: imagen, body: body, state: state, video: video )
        puts 'Si Existe Actualicemelo Y tiene video'
      end
      post = nil
    else
      if state
        Post.create(name: name, url: link_con, image: imagen, body: body, sources: sources, state: state, video: video )
        puts 'Si No Existe Creemelo'
      else
        Post.create(name: name, url: link_con, image: imagen, body: body, sources: sources, state: state, video: video )
        puts 'Si No Existe Creemelo'
      end
      post = nil
    end   
  end
end
