class Api::V1::ItemsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items) if params[:merchant_id]
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def destroy
    Item.destroy(params[:id])
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end

end