class IntentsController < ApplicationController
  before_action :set_intent, only: [:show, :edit, :update, :destroy]
  before_action :find_bot, only: [:new, :edit, :create, :update, :destroy]
  skip_after_action :verify_authorized

  def index
    @intent = Intent.all
  end

  def new
    @intent = Intent.new
  end

  def edit
  end

  def create
    @intent = @bot.intents.build(intent_params)
    if @intent.save
      redirect_to edit_bot_path(@bot, active: :patterns)
    else
      render :new
    end
  end

  def update
    if @intent.update(intent_params)
      redirect_to edit_bot_path(@bot, active: :patterns)
    else
      render :edit
    end
  end

  def destroy
    @intent.destroy
    redirect_to edit_bot_path(@bot, active: :patterns)
  end

  private
    def set_intent
      @intent = Intent.find(params[:id])
    end

    def find_bot
      @bot = Bot.find(params[:bot_id])
    end

    def intent_params
      params.require(:intent).permit(:bot, :name, :answer)
    end
end

