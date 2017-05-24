class BadgesController < ApplicationController
  after_action :verify_authorized, except: [:index]
  before_action :set_badge, only: [:show, :edit, :update, :destroy]

  # GET /badges
  def index
    scope = Badge.by_position
    @badges = scope.page(params[:page]).per(10)
  end

  # GET /badges/1
  def show
    @users = @badge.users.page(params[:page])
  end

  # GET /badges/new
  def new
    @badge = Badge.new
    authorize @badge
  end

  # GET /badges/1/edit
  def edit
  end

  # POST /badges
  def create
    @badge = Badge.new(badge_params)
    authorize @badge

    if @badge.save
      redirect_to @badge, notice: 'Badge was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /badges/1
  def update
    if @badge.update(badge_params)
      redirect_to @badge, notice: 'Badge was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /badges/1
  def destroy
    @badge.destroy
    redirect_to badges_url, notice: 'Badge was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_badge
      @badge = Badge.friendly.find(params[:id])
      authorize @badge
    end

    # Only allow a trusted parameter "white list" through.
    def badge_params
      params.require(:badge).permit(:name, :slug, :description, :earned_by, :position,
        :avatar, :retained_avatar, :remove_avatar, :avatar_url
      )
    end
end
