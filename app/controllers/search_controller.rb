class SearchController < ApplicationController
  def index
    get_results
  end

  def jobs
    get_results("Job")
    render :index
  end

  def projects
    get_results("Project")
    render :index
  end

  def members
    get_results("User")
    render :index
  end

  def companies
    get_results("Company")
    render :index
  end

  def get_results(type = nil)
    @searchable_type = type
    @query = params[:q]
    @page = params[:page]

    if @searchable_type.present?
      @results = PgSearch.multisearch(@query).where(:searchable_type => @searchable_type).page(@page).per(10)
    else
      @results = PgSearch.multisearch(@query).page(@page).per(10)
    end
  end
end
