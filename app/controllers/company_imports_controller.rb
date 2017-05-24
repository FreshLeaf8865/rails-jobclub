class CompanyImportsController < ApplicationController
  def new
    @company = Company.new
  end

  def create
    facebook_url = params[:company][:facebook_url]
    @company = Company.import_facebook_url(facebook_url)
    if @company && @company.persisted?
      @company.added_by = current_user
      @company.save
      redirect_to @company
    else
      redirect_to new_company_import_path, alert: "There was an error importing #{facebook_url}"
    end

    
  end

  def search
    @results = FacebookService.search_pages(params[:query])

    respond_to do |format|
      format.json { render json: @results }
    end
  end
end
