class RepliesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @reply = @post.replies.create(params[:reply].permit(:content,:user_id,:post_id))
    @reply.user = current_user
    if @reply.save
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end
end
