class Api::V1::MerchantsController < ApplicationController

  def index
    page = params[:page] || 1
    binding.pry
    @merchants = Merchant.all.offset(page * 20).limit(20)
  end

end