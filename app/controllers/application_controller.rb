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

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_unprocessable_entity_response(exception)
    render json: { 
      error: [exception.record.errors],
      message: "Your request could not be completed"
      }, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { 
      error: [exception.message, '404 Not Found'],
      message: 'Entity not found.'
       }, status: :not_found
  end
end
