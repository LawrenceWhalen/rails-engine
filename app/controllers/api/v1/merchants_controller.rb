class Api::V1::MerchantsController < ApplicationController

  def index
    offset_limit = page_offest(params)
    render json: MerchantSerializer.new(Merchant.all.offset(offset_limit[:offset]).limit(offset_limit[:limit]))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end