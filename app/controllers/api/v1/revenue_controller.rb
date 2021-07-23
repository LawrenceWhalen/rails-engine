class Api::V1::RevenueController < ApplicationController

  def merchants
    if params[:quantity].to_i >= 1
      render json: MerchantNameRevenueSerializer.new(Merchant.top_merchants.limit(params[:quantity]))
    else
      render json: { 
        error: ['Must send a quantity', 'Quantity must be a postive number'],
        message: "Your request could not be completed"
        }, status: :bad_request
    end
  end

  def unshipped
    if !params[:quantity] || params[:quantity].to_i >= 1
      params[:quantity] = 10 if !params[:quantity]
      render json: UnshippedOrderSerializer.new(Merchant.unshipped_revenue.limit(params[:quantity]))
    else
      render json: { 
        error: ['Quantity must be one or greater'],
        message: "Your request could not be completed"
        }, status: :bad_request
    end
  end

  def items
    if !params[:quantity] || params[:quantity].to_i >= 1
      params[:quantity] = 10 if !params[:quantity]
      render json: ItemRevenueSerializer.new(Item.top_items.limit(params[:quantity]))
    else
      render json: { 
        error: ['Quantity must be one or greater'],
        message: "Your request could not be completed"
        }, status: :bad_request
    end
  end

  def merchant_show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(MerchantRev.new(id: merchant.id, revenue: merchant.total_revenue))
  end

end