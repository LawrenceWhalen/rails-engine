class Api::V1::RevenueController < ApplicationController

  def index
    if params[:quantity].to_i >= 1
      render json: MerchantRevenueSerializer.new(Merchant.top_merchants.limit(params[:quantity]))
    else
      render json: { 
        error: ['Must send a quantity', 'Quantity must be a postive number'],
        message: "Your request could not be completed"
        }, status: :unprocessable_entity
    end
  end

end