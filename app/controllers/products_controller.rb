class ProductsController < ApplicationController
  before_action :set_pattern, only: [:show, :edit, :update, :destroy]
  before_action :find_bot, only: [:new, :edit, :create, :update, :destroy]
  skip_after_action :verify_authorized



private
  def set_product
    @product = Product.find(params[:id])
  end

  def find_bot
    @bot = Bot.find(params[:bot_id])
  end

  def product_params
    params.require(:product).permit(:photo, :photo_cache)
  end
end
