class Api::V1::ItemsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    if params[:merchant_id]
      render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    else
      offset_limit = page_offest(params)
      render json: ItemSerializer.new(Item.all.offset(offset_limit[:offset]).limit(offset_limit[:limit]))
    end
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

  def update
    Merchant.find(params[:merchant_id]) if params[:merchant_id]
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: ItemSerializer.new(item), status: :accepted
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end

end