class BotsController < ApplicationController
  before_action :set_bot, only: [:analytic, :guide, :show, :edit, :update, :destroy, :webhook_verification, :webhook]

  skip_before_action :authenticate_user!, only: [:webhook, :webhook_verification]
  skip_after_action :verify_authorized, only: [:webhook, :webhook_verification]
  skip_before_filter  :verify_authenticity_token, only: [:webhook, :webhook_verification]

  def analytic
  end

  def webhook_verification
    @bot = Bot.find(params[:id])
    if params['hub.mode'] == 'subscribe' && params['hub.verify_token'] == @bot.token
      render json: params['hub.challenge'], status: :ok
    else
      render json: {}, status: :forbidden
    end
  end

  def webhook
    # 0 Verify token

    # 1 - Parse message
    message_text = params['entry'][0]['messaging'][0]['message']['text']
    message_sender_id = params['entry'][0]['messaging'][0]['sender']['id']
    if message_text && message_sender_id
      # 2 - Init Job
      ProcessBotMessageJob.perform_later(message_sender_id, message_text, @bot)
    end

    # 3 - 200
    render nothing: true, status: 200
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
    @pattern = Pattern.new
  end

  def create
    @bot = current_user.bots.build(bot_params)
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
      authorize @bot
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bot_params
      params.require(:bot).permit(:name, :token, :enable)
    end
end
