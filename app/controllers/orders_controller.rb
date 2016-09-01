class OrdersController < ApplicationController
  before_action :set_order, only: [ :edit, :update]
  before_action :find_bot, only: [:edit, :update]
  skip_after_action :verify_authorized

  def index
    @orders = policy_scope(Order)
  end

  def edit
  end

  def update
    if @order.update(product_params)
      redirect_to edit_bot_path(@bot)
    else
      render :edit
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def find_bot
    @bot = Bot.find(params[:bot_id])
  end

  def order_params
    params.require(:order).permit(:product, :address, :status)
  end
end
