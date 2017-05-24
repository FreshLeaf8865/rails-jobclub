class FeedController < ApplicationController
  def index
    @activities = Activity.only_public.published.public_display.by_recent.page(params[:page])
  end
end
