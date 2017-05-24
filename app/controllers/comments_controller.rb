class CommentsController < ApplicationController
  after_action :verify_authorized, except: [:index]

  def create
    @comment = @commentable.comments.new comment_params
    authorize @comment
    @comment.user = current_user
    
    if @comment.save 
      redirect_to @commentable, notice: "Comment posted."
    else
      redirect_to @commentable
    end
  end

  def destroy
    set_comment
    @comment.destroy
    redirect_to @comment.commentable, alert: "Comment deleted."
  end

  def like
    set_comment
    @comment.like!(current_user)
    @comment.reload
    respond_to do |format|
      format.js {  render :like }
      format.html { redirect_to @comment.commentable, notice: "Comment liked"}
    end
  end

  def unlike
    set_comment
    @comment.unlike!(current_user)
    @comment.reload
    respond_to do |format|
      format.js {  render :like }
      format.html { redirect_to @comment.commentable, notice: "Comment unliked"}
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
      authorize @comment
    end

    def comment_params
      params.require(:comment).permit(:text)
    end
end