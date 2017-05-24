class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index]

  # GET /jobs
  def index
    scope = Job.recent
    @jobs = scope.page(params[:page]).per(10)
  end

  # GET /jobs/1
  def show
    impressionist(@job)
  end

  # GET /jobs/new
  def new
    @job = Job.new
    authorize @job
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  def create
    @job = current_user.jobs.build(job_params)

    authorize @job

    if @job.save
      @job.publish!
      redirect_to @job, notice: 'Job was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /jobs/1
  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /jobs/1
  def destroy
    @job.destroy
    redirect_to jobs_url, notice: 'Job was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.friendly.find(params[:id])
      authorize @job
    end

    # Only allow a trusted parameter "white list" through.
    def job_params
      params.require(:job).permit(:name, :slug, :company_id, :location_id, :role_id, :skills_list,
        :description, :link,
        :full_time,
        :part_time,
        :remote,
        :contract,
        :internship)
    end
end
