class ReviewRequestsController < ApplicationController
  after_action :verify_authorized, except: [:index]
  before_action :set_review_request, only: [:show, :edit, :update, :destroy]

  # GET /review_requests
  def index
    @review_requests = current_user.review_requests
  end

  # GET /review_requests/1
  def show
    impressionist(@review_request)
  end

  # GET /review_requests/new
  def new
    @review_request = ReviewRequest.new
    authorize @review_request
  end

  # GET /review_requests/1/edit
  def edit
  end

  # POST /review_requests
  def create
    @review_request = current_user.review_requests.build(review_request_params)
    authorize @review_request
    if @review_request.save
      redirect_to @review_request, notice: 'Your request has been submitted.'
    else
      render :new
    end
  end

  # PATCH/PUT /review_requests/1
  def update
    if @review_request.update(review_request_params)
      redirect_to @review_request, notice: 'Review request was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /review_requests/1
  def destroy
    @review_request.destroy
    redirect_to current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review_request
      @review_request = ReviewRequest.find(params[:id])
      authorize @review_request
    end

    # Only allow a trusted parameter "white list" through.
    def review_request_params
      params.require(:review_request).permit(:goal)
    end
end
