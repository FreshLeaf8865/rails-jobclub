class ReviewRequests::CommentsController < CommentsController
  before_action :set_commentable

  private
    def set_commentable
      @commentable = ReviewRequest.find(params[:review_request_id])
    end
end