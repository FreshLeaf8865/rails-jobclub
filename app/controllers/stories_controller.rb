class StoriesController < ApplicationController
  after_action :verify_authorized, except: [:index, :drafts]
  before_action :set_story, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  # GET /stories
  def index
    @stories = Story.published

    scope = Story.published
    if params[:sort_by] == "oldest"
      scope = scope.by_oldest
    elsif params[:sort_by] == "popular"
      scope = scope.by_popular
    else
      scope = scope.by_recent
    end

    if params[:query]
      scope = scope.search_by_name(params[:query])
    end

    @stories = scope.page(params[:page]).per(10)

    respond_to do |format|
      format.json { render json: @stories }
      format.html
    end
  end

  def drafts
    @stories = current_user.stories.drafts.page(params[:page]).per(10)
    render :index
  end

  # GET /stories/1
  def show
    impressionist(@story)
  end

  # GET /stories/new
  def new
    @story = Story.new
    authorize @story
  end

  # GET /stories/1/edit
  def edit
  end

  # POST /stories
  def create
    @story = current_user.stories.build(story_params)

    authorize @story

    if @story.save
      redirect_to @story, notice: 'Story was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /stories/1
  def update
    if @story.update(story_params)
      redirect_to @story, notice: 'Story was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /stories/1
  def destroy
    @story.destroy
    redirect_to stories_url, notice: 'Story was successfully destroyed.'
  end

  def publish
    @story.publish!
    redirect_to @story, notice: 'Your story was published!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.friendly.find(params[:id])
      authorize @story
    end

    # Only allow a trusted parameter "white list" through.
    def story_params
      params.require(:story).permit(:name, :cover_uid, :content, :slug, :tags_list, :cover, :retained_cover, :remove_cover, :cover_url)
    end
end
