class Stories::CommentsController < CommentsController
  before_action :set_commentable

  private
    def set_commentable
      @commentable = Story.friendly.find(params[:story_id])
    end
end
