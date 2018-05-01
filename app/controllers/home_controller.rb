class HomeController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'graphql'
  require 'json'

  before_action :authenticate_user!, :only => ['scraping']

  before_action :covers_header

  def index
    @posts = Post.where(state: true).limit(60).order(created_at: :desc)
    @covers = Cover.where(status: true).limit(5).order(created_at: :desc)
    @post_tag = Post.all#where('created_at >= :uno and state == :dos', :uno  => Time.now - 25.days, :dos => true).limit(4).order(views: :desc)
    @posts_top = Post.all#where('created_at >= :uno and state == :dos', :uno  => Time.now - 15.days, :dos => true).limit(10).order(views: :desc)
  end

  def noticias
    if params[:page]
      @posts = Post.where(state: true).order(created_at: :desc).page(params[:page]).per(60)
    else
      @posts = Post.where(state: true).order(created_at: :desc).page(1).per(60)
    end
  end

  def noticia
    @post =  Post.friendly.find(params[:id])    
    @post.update(views: @post.views + 1)
    @posts = Post.where(state: true).order(created_at: :desc).page(1).per(60)
  end

  def categoria 
    @category =  Category.friendly.find(params[:id])
  end

  def buscar
    #@posts = Post.where("name LIKE ? OR body LIKE ? OR name LIKE ? OR body LIKE ? OR name LIKE ? OR body LIKE ? OR name LIKE ? OR body LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q].downcase}%", "%#{params[:q].downcase}%", "%#{params[:q].titleize}%", "%#{params[:q].titleize}%", "%#{params[:q].capitalize}%", "%#{params[:q].capitalize}%" ).order(created_at: :desc)
    @areglo = []
    params[:q].split.each do |palabra|
      @areglo << Post.where("name LIKE ? or body LIKE ? or name LIKE ? or body LIKE ? or name LIKE ? or body LIKE ? or name LIKE ? or body LIKE ?", "%#{palabra}%", "%#{palabra}%", "%#{palabra.downcase}%", "%#{palabra.downcase}%", "%#{palabra.titleize}%", "%#{palabra.titleize}%", "%#{palabra.capitalize}%", "%#{palabra.capitalize}%").where(state:true).order(:name)
    end
    @posts = @areglo[0]
    render 'buscar'
  end

  def videos
    #@posts = Post.where("name LIKE ? or body LIKE ? ", "%#{params[:id]}%", "%#{params[:id]}%").order(created_at: :desc)
    @posts = Post.friendly.find(params[:id])
    @areglo = []
    @posts.name.split.each do |palabra|
      @areglo << Post.where("name LIKE ? or body LIKE ? or name LIKE ? or body LIKE ? or name LIKE ? or body LIKE ? or name LIKE ? or body LIKE ?", "%#{palabra}%", "%#{palabra}%", "%#{palabra.downcase}%", "%#{palabra.downcase}%", "%#{palabra.titleize}%", "%#{palabra.titleize}%", "%#{palabra.capitalize}%", "%#{palabra.capitalize}%").where(state:true).order(:name)
    end
    @posts = @areglo[0]
    render 'buscar'
    
  end

  def scraping
    
    if params['url'] and params['url'].include?('http://www.cliver.tv') #solo si url es igual a https://vepeliculas.tv/
      url =  params['url']
      document = Nokogiri::HTML(open(url))
      div_main = document.css('div.contenedor div.int-cont section.panel-der')
      div_main.css('div.contenidos-p article.contenido-p').each do |post|
        imagen = post.css('div.portada-p').css('a img').attr('src')
        link_con = post.css('div.portada-p').css('a').attr('href')
        name = post.css('div.titulo-p').css('a h2').text
        url = post.css('div.portada-p').css('a').attr('href')
        document = Nokogiri::HTML(open(url))
        cont = document.css('script')#css('div.contenedor div.int-cont section.peli-izq').xpath('uVXUkRb4GQ')
        contador = 0
        sources = 'cliver.tv'#url
        video = nil
        body = document.css('div.contenedor div.int-cont section.peli-izq div.descripcion-pelicula p')[1].to_s.gsub('</p>', '').gsub('<p>', '') 
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
    elsif params['url'] and params['url'].include?('http://www.planetatvonlinehd.com') #OK 
      url = params['url']
      document = Nokogiri::HTML(open(url))
      div_main = document.css('main div.ed-item section.box')
      div_main.css('div.homelist').each do |post|
      name = post.css('a').text
      link_con = post.css('a').attr('href')
      document = Nokogiri::HTML(open(link_con))
      imagen = document.css('section.container main.ed-item article.single section.single__content').css('img').attr('src')
      body2 = document.css('section.container main.ed-item article.single section.single__content').css('p').text.to_s
      body = body2.to_s.gsub('\n', '').gsub('📌', '').gsub('❗️', '')
      sources = 'planetatvonlinehd'#url
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
                #puts item.css('div.content div.video').css('div.video').css('script')
                video = "https://openload.co/embed/#{codigo.to_s}/"
            end
            state = !video.nil? and !imagen.nil?
          end
          Post.create_scraping(name, link_con, state, imagen, body, video, sources)
      end  
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
