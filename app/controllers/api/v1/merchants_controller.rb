class Api::V1::MerchantsController < ApplicationController

  def index
    offset_limit = page_offest(params)
    render json: MerchantSerializer.new(Merchant.all.offset(offset_limit[:offset]).limit(offset_limit[:limit]))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    search = params[:name]

    merchant = Merchant.find_name(search)
    if merchant != []
      render json: MerchantSerializer.new(merchant[0])
    else
      render json: {data: {}}
    end
  end

  def find_all
    search = params[:name]

    merchant = Merchant.find_name(search)
    if merchant != []
      render json: MerchantSerializer.new(merchant)
    else
      render json: {data: {}}
    end
  end
end