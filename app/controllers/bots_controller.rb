class BotsController < ApplicationController
  before_action :set_bot, only: [:analytic, :show, :edit, :update, :destroy, :webhook_verification, :webhook, :webhook_subscribe]

  skip_before_action :authenticate_user!, only: [:webhook, :webhook_verification]
  skip_after_action :verify_authorized, only: [:webhook, :webhook_verification, :guide]
  skip_before_action  :verify_authenticity_token, only: [:webhook, :webhook_verification]


  def analytic
    @bot = Bot.find(params[:id])
  end

  def webhook_verification
    @bot = Bot.find(params[:id])
    if params['hub.mode'] == 'subscribe' && params['hub.verify_token'] == @bot.token
      render json: params['hub.challenge'], status: 200
    else
      render json: {}, status: :forbidden
    end
  end

  def webhook
    p params
    # 0 Verify token
    # 1 - Parse message
    p 'webhook_request'
    if params['entry'][0]['messaging'][0]['message']
      message_text = params['entry'][0]['messaging'][0]['message']['text']
      message_sender_id = params['entry'][0]['messaging'][0]['sender']['id']
      p params
      p 'webhook_request_accepted'
      if message_text && message_sender_id
        # 2 - Init Job
        ProcessBotMessageJob.perform_later(message_sender_id, message_text, @bot)
      end
    end

    # 3 - 200
    render nothing: true, status: 200
  end

  def webhook_subscribe
    if FacebookRequestService.subscribe(@bot.page_access_token)
      redirect_to :index
    else
      flash[:alert] = "Error when refresh subscribe"
      redirect_to :index
    end
  end

  def guide
    @bot = Bot.find(params[:id])
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
    get_opening_times
    @pattern = Pattern.new
  end

  def create
    @bot = current_user.bots.build(bot_params)
    @bot.info = GoogleApiService.place_detail(@bot)
    authorize @bot
    if @bot.save
      redirect_to bots_path, notice: 'Bot was successfully created.'
    else
      render :new
    end
  end

  def update
    if @bot.update(bot_params)
      redirect_to edit_bot_path(@bot), notice: 'Bot was successfully updated.'
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

    def get_opening_times
      @opening_and_closing = ''
      @bot.info['result']['opening_hours']['weekday_text'].each do |day|
        @opening_and_closing += "#{day}\n"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bot_params
      params.require(:bot).permit(:name, :shop_name, :street, :city, :token, :enable, :page_access_token, :info)
    end
end
