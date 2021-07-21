class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items) if params[:merchant_id]
    
  end

end