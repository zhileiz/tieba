class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    ding = Post.all.order("created_at desc").to_a.keep_if{|b| b.sticky == true}
    posts = Post.all.order("created_at desc").to_a.keep_if{|b| b.replies.count == 0 && b.sticky == false}
    temp = Post.includes(:replies).order("replies.created_at desc").to_a.reject{|a| a.replies.count == 0 || a. sticky == true}
    @posts = []
    left = 0
    right = 0
    while !posts.empty? && !temp.empty?
      if (posts[left].created_at > temp[right].replies.first.created_at)
        @posts.push(posts.delete_at(left))
      else
        @posts.push(temp.delete_at(right))
      end
    end
    if posts.empty?
      @posts = ding.concat(@posts.concat(temp))
    else
      @posts = ding.concat(posts.concat(@posts))
    end
    @posts = Kaminari.paginate_array(@posts).page(params[:page])
    if user_signed_in?
      @post = current_user.posts.build
    end
  end

  def indexbypost
    ding = Post.all.order("created_at desc").to_a.keep_if{|b| b.sticky == true}
    @posts = Post.all.order("created_at desc").to_a.keep_if{|b| b.sticky == false}
    @posts = ding.concat(@posts)
    @posts = Kaminari.paginate_array(@posts).page(params[:page])
    if user_signed_in?
      @post = current_user.posts.build
    end
  end

  def indexbyreply
    ding = Post.all.order("created_at desc").to_a.keep_if{|b| b.sticky == true}
    @posts = Post.includes(:replies).order("replies.created_at desc").to_a.reject{|a| a. sticky == true}
    @posts = ding.concat(@posts)
    @posts = Kaminari.paginate_array(@posts).page(params[:page])
    if user_signed_in?
      @post = current_user.posts.build
    end
  end

  def indexbypop
    ding = Post.all.order("created_at desc").to_a.keep_if{|b| b.sticky == true}
    posts = Post.includes(:replies).order("replies.created_at desc").to_a.reject{|a| a. sticky == true}
    @posts = Post.joins(:replies).group("posts.id").order("count(replies.id) desc").to_a.reject{|a| a. sticky == true}
    posts.each do |post|
      if post.replies.count == 0
        @posts.push(post)
      end
    end
    @posts = ding.concat(@posts)
    @posts = Kaminari.paginate_array(@posts).page(params[:page])
    if user_signed_in?
      @post = current_user.posts.build
    end
  end

  def upvote
    @post = Post.find(params[:id])
    @post.upvote_by current_user
    redirect_to :back
  end

  def makejing
    @post = Post.find(params[:id])
    unless @post.jing
      @post.update(jing:true)
    end
    redirect_to :back
  end

  def makesticky
    @post = Post.find(params[:id])
    unless @post.sticky
      @post.update(sticky:true)
    end
    redirect_to :back
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @mobile = @post
    @mobile_replies = @post.replies.to_a.keep_if{|b| b.id != nil}
    @replies = @post.replies
  end

  def jingping
    @posts = Post.all.order("created_at desc").to_a.keep_if{|i| i.jing == true}
    @posts = Kaminari.paginate_array(@posts).page(params[:page])
    if user_signed_in?
      @post = current_user.posts.build
    end
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)

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
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :user_id)
    end
end
