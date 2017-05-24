class Jobs::CommentsController < CommentsController
  before_action :set_commentable

  private
    def set_commentable
      @commentable = Job.friendly.find(params[:job_id])
    end
end
