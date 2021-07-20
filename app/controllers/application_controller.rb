class ApplicationController < ActionController::Base

  private

  def page_offest(params)
    page = params[:page] || 1
    limit = params[:per_page] || 20
    if page.to_i <= 0
      page = 1
    end
    if limit.to_i <= 0
      limit = 20
    end
    {offset: (page.to_i - 1) * limit.to_i, limit: limit.to_i}
  end
end
