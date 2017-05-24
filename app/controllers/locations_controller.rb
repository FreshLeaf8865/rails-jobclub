class LocationsController < ApplicationController
  def index
    @locations = Location.search_by_name(params[:query]).by_users_count.page(params[:page])
    render json: @locations
  end
end