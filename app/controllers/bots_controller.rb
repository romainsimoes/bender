class BotsController < ApplicationController
  before_action :set_bot, only: [:show, :edit, :update, :destroy]

  def analytic
  end

  def webhook
  end

  def guide
  end

  def index
    @bots = policy_scope(Bot)
  end

  def show
  end

  def new
    @bot = Bot.new
    authorize @bot
  end

  def edit
  end

  def create
    @bot = Bot.new(bot_params)
    @bot.user = current_user
    authorize @bot
    if @bot.save
      redirect_to bots_path, notice: 'Bot was successfully created.'
    else
      render :new
    end
  end

  def update
    if @bot.update(bot_params)
      redirect_to @bot, notice: 'Bot was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @bot.destroy
    redirect_to bots_path, notice: 'Bot was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bot
      @bot = Bot.find(params[:id])
      authorize @restaurant
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bot_params
      params.require(:bot).permit(:name, :token, :enable)
    end
end
