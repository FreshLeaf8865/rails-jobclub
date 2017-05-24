class LikesController < ApplicationController
  before_action :authenticate_user!
  #after_action :verify_authorized, except: [:index]
  before_action :set_like, only: [:show, :destroy]

  # GET /likes
  def index
    redirect_to root_path unless current_user.is_admin
    scope = Like.recent
    @likes = scope.page(params[:page]).per(10)
  end
  
  # GET /likes/new
  def new
    @like = Like.new
    #authorize @like
  end

  # POST /likes
  def create
    @like = Like.new(like_params)
    #authorize @like
    @like.user = current_user
    @likeable = @like.likeable

    if @like.save
      respond_to do |format|
        format.js {  render :update }
        format.html { redirect_to likes_path, notice: 'Like was successfully created.'}
      end
    else
      render :new
    end
  end

  # DELETE /likes/1
  def destroy
    @likeable = @like.likeable
    @like.destroy
    respond_to do |format|
      format.js {  render :update }
      format.html { redirect_to likes_url, notice: 'Like was successfully destroyed.'}
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
      #authorize @like
    end

    # Only allow a trusted parameter "white list" through.
    def like_params
      params.require(:like).permit(:likeable_id, :likeable_type, :likeable)
    end
end
