class Milestones::CommentsController < CommentsController
  before_action :set_commentable

  private
    def set_commentable
      @commentable = Milestone.find(params[:milestone_id])
    end
end