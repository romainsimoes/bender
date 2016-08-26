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
    begin
      message_text = params['entry'][0]['messaging'][0]['message']['text']
      message_sender_id = params['entry'][0]['messaging'][0]['sender']['id']
      p params
      if message_text && message_sender_id
        # 2 - Init Job
        ProcessBotMessageJob.perform_later(message_sender_id, message_text, @bot)
      end
    rescue
      p 'Error parsing'
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
    @pattern = Pattern.new
  end

  def create
    @bot = current_user.bots.build(bot_params)
    @bot.info = place_detail
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

  def geocode_parsing
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI::escape(@bot.street)} #{URI::escape(@bot.city)}"
    response = RestClient.get(url)
    json = JSON.parse(response)
    location = { lat: json["results"][0]["geometry"]["location"]["lat"], lng: json["results"][0]["geometry"]["location"]["lng"] }
  end

  def place_id_parsing(location)
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location[:lat]},#{location[:lng]}&name=#{URI::escape(@bot.shop_name)}&key=#{ENV['GOOGLE_API_KEY']}"
    response = RestClient.get(url)
    json = JSON.parse(response)
    return if json["status"] == "ZERO_RESULTS"
    places = json["results"].select{ |n| n["name"].length == @bot.shop_name.length }
    place = places.select{ |n| n["vicinity"].length == "#{@bot.street}, #{@bot.city}".length }
    return place[0]["place_id"]
  end

  def place_detail
    location = geocode_parsing
    place_id = place_id_parsing(location)
    url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&key=#{ENV['GOOGLE_API_KEY']}"
    response = RestClient.get(url)
    return JSON.parse(response)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bot
      @bot = Bot.find(params[:id])
      authorize @bot
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bot_params
      params.require(:bot).permit(:name, :shop_name, :street, :city, :token, :enable, :page_access_token)
    end
end
