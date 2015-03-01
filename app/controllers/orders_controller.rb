class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html


  def new
    @order = Order.new
    @listing = Listing.find(params[:listing_id])
  end

  def create
    @order = Order.new(order_params)
    @listing = Listing.find(params[:listing_id])
    @seller = @listing.user

    @order.listing_id = @listing.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id

    if @order.save
      redirect_to root_url, notice: "Order successfully created!"
    else
      render 'new'
    end
  end

  def sales
    @orders = Order.where(seller: current_user).order("created_at DESC")
  end

  def purchases
    @orders = Order.where(buyer: current_user).order("created_at DESC")
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:address, :city, :state)
    end
end
