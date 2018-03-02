class HomeController < ApplicationController
  def index
  end

  def noticias
    @posts = Post.where(state: true)
  end
end
