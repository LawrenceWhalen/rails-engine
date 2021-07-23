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

  def find
    route = params_check(params)
    if route == 'name'
      find_name(params[:name])
    elsif route == 'price'
      find_price(params)
    else
      render json: { 
        error: ['Cannot pass both price and name', 'Minimum price cannot be higher than maximum price'],
        message: "Your request could not be completed"
        }, status: :unprocessable_entity
    end
  end

  def find_all
    route = params_check(params)
    if route == 'name'
      find_name_all(params[:name])
    elsif route == 'price'
      find_price_all(params)
    else
      render json: { 
        error: ['Cannot pass both price and name', 'Minimum price cannot be higher than maximum price'],
        message: "Your request could not be completed"
        }, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end

  def find_name(search)
    item = Item.find_name(search)
    if item != []
      render json: ItemSerializer.new(item[0])
    else
      render json: {data: {}}
    end
  end

  def find_price(search)
    item = Item.find_price(search)
    if item != []
      render json: ItemSerializer.new(item[0])
    else
      render json: {data: {}}
    end
  end

  def find_name_all(search)
    item = Item.find_name(search)
    if item != []
      render json: ItemSerializer.new(item)
    else
      render json: {data: []}
    end
  end

  def find_price_all(search)
    item = Item.find_price(search)
    if item != []
      render json: ItemSerializer.new(item)
    else
      render json: {data: {}}
    end
  end

  def params_check(params)
    if params[:name] && (params[:min_price] || params[:max_price])
      'error'
    elsif params[:name]
      'name'
    elsif (params[:min_price] && params[:max_price]) && (params[:min_price].to_i > params[:max_price].to_i)
      'error'
    elsif params[:min_price] || params[:max_price]
      'price'
    else
      'error'
    end
  end

end