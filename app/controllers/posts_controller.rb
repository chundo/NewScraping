class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    #@posts = Post.where(state: true).order(created_at: :desc).page(1).per(6)
    @posts = Post.where("name LIKE ? OR body LIKE ? OR name LIKE ? OR body LIKE ? OR name LIKE ? OR body LIKE ? OR name LIKE ? OR body LIKE ?", "%#{@post.name[0..6]}%", "%#{@post.name[0..6]}%", "%#{@post.name.downcase[0..6]}%", "%#{@post.name.downcase[0..6]}%", "%#{@post.name.titleize[0..6]}%", "%#{@post.name.titleize[0..6]}%", "%#{@post.name.capitalize[0..6]}%", "%#{@post.name.capitalize[0..6]}%" ).order(name: :desc).limit(6)
    #con = 6 - 1
    #@post_o = Post.where("name LIKE ? OR body LIKE ? OR name LIKE ? OR body LIKE ? OR name LIKE ? OR body LIKE ? OR name LIKE ? OR body LIKE ?", "%#{@posts.last.name[0..6]}%", "%#{@posts.last.name[0..6]}%", "%#{@posts.last.name.downcase[0..6]}%", "%#{@posts.last.name.downcase[0..6]}%", "%#{@posts.last.name.titleize[0..6]}%", "%#{@posts.last.name.titleize[0..6]}%", "%#{@posts.last.name.capitalize[0..6]}%", "%#{@posts.last.name.capitalize[0..6]}%" ).order(name: :desc).limit(con)
    
    render '/home/noticia'
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:name, :body, :image, :url, :sources, :video, :cover, :state, :category_id, :views)
    end
end
