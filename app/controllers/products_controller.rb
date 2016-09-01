class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :find_bot, only: [:new, :edit, :create, :update, :destroy]
  skip_after_action :verify_authorized

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = @bot.products.build(product_params)
    if @product.save
      redirect_to edit_bot_path(@bot, active: :orders)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @pattern.update(pattern_params)
      redirect_to edit_bot_path(@bot, active: :orders)
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to edit_bot_path(@bot, active: :orders)
  end

private
  def set_product
    @product = Product.find(params[:id])
  end

  def find_bot
    @bot = Bot.find(params[:bot_id])
  end

  def product_params
    params.require(:product).permit(:photo, :photo_cache, :name, :description, :price)
  end
end
