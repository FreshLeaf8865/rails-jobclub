class ProjectsController < ApplicationController
  before_action :sign_up_required, except: [:show, :index]
  after_action :verify_authorized, except: [:index]

  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    scope = Project.with_image
    @title = "Projects"

    if params[:sort_by] == "popular"
      scope = scope.by_likes
    elsif params[:sort_by] == "oldest"
      scope = scope.by_oldest
    else
      scope = scope.by_recent
    end

    if params[:username]
      @user = User.friendly.find(params[:username])
      scope = scope.by_user(@user)
      @title = "#{@title} by #{@user.display_name}"
    end

    if params[:skill]
      scope = scope.with_any_skills(params[:skill])
      @title = "#{params[:skill]} #{@title}"
    end

    @projects = scope.page(params[:page]).per(12)
  end

  # GET /projects/1
  def show
    impressionist(@project)
  end

  # GET /projects/new
  def new
    @project = current_user.projects.build
    authorize @project
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = current_user.projects.build(project_params)
    authorize @project
    
    if @project.save
      redirect_to project_path(@project), notice: 'Project added'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      @project.reload
      redirect_to project_path(@project), notice: 'Project updated'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    respond_to do |format|
      format.js   { render layout: false }
      format.html { redirect_to current_user, notice: 'Project deleted' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])
      authorize @project
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :slug, :position, :image, :retained_image, :remove_image, :image_url, :link, :description, :skills_list, :company_id)
    end
end
