class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items) if params[:merchant_id]
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end