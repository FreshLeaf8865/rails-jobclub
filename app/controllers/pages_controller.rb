class PagesController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def letsencrypt
    render text: "_5YKrz0MKo7WNb6faA2CUAFZ8ShmeGnl_yB0jtyRl8c.R7J5HZzwF8y8D6YdxAG8krBSycV1w9M5sE1GG7lC-oM"
  end
end
