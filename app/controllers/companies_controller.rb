class CompaniesController < ApplicationController
  after_action :verify_authorized, except: [:index]
  before_action :set_company, only: [:show, :edit, :update, :destroy, :refresh]

  # GET /companies
  def index
    scope = Company.all
    if params[:sort_by] == "popular"
      scope = scope.by_followers
    elsif params[:sort_by] == "alphabetical"
      scope = scope.alphabetical
    elsif params[:sort_by] == "oldest"
      scope = scope.oldest
    else
      scope = scope.recent
    end

    if params[:query]
      scope = scope.search_by_name(params[:query])
    end

    @companies = scope.page(params[:page]).per(10)

    respond_to do |format|
      format.json { render json: @companies }
      format.html
    end
  end

  # GET /companies/1
  def show
    impressionist(@company)
  end

  def follow
    set_company

    unless user_signed_in?
      # take us to sign up if we aren't logged in
      store_location(follow_company_path(@company))
      redirect_to(new_user_registration_path, format: :html) and return
    end

    current_user.follow @company
    @company.reload
    
    respond_to do |format|
      format.js { render :follow}
      format.html { redirect_to @company }
    end
  end

  def unfollow
    set_company
    
    current_user.stop_following @company
    @company.reload
    
    respond_to do |format|
      format.js { render :follow}
      format.html { redirect_to @company }
    end
  end

  def refresh
    if @company.refresh
      notice = "Company Refreshed"
    end
    redirect_to @company, notice: notice
  end

  # GET /companies/new
  def new
    @company = Company.new
    authorize @company
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    authorize @company
    @company.added_by = current_user

    if @company.save
      redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
    redirect_to companies_url, notice: 'Company was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.friendly.find(params[:id])
      authorize @company
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit(:name, :slug, :twitter_url, :facebook_url, :instagram_url, :angellist_url, :website_url, :tagline,
        :avatar, :retained_avatar, :remove_avatar, :avatar_url, :tags_list,
        :logo, :retained_logo, :remove_logo, :avatar_logo)
    end
end
