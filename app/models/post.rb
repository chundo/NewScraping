class Post < ApplicationRecord
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :labeling
  has_many :tags, through: :labeling
  
  extend FriendlyId
  friendly_id :name, use: :slugged

  self.paginates_per  60
  

  def self.create_scraping(name, link_con, state, imagen, body, video, sources)
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

  before_save :default_values
  def default_values
    self.views ||= 0 # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end

end
