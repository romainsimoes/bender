class PatternsController < ApplicationController
  before_action :set_pattern, only: [:show, :edit, :update, :destroy]
  before_action :find_bot, only: [:new, :edit, :create, :update, :destroy]
  skip_after_action :verify_authorized

  def index
    @pattern = Pattern.all
  end

  def new
    @pattern = Pattern.new
  end

  def edit
  end

  def create
    @pattern = @bot.patterns.build(pattern_params)
    if @pattern.save
      @bot.intent << @pattern.trigger
      @bot.save
      redirect_to edit_bot_path(@bot, active: :patterns)
    else
      render :new
    end
  end

  def update
    if @pattern.update(pattern_params)
      redirect_to edit_bot_path(@bot, active: :patterns)
    else
      render :edit
    end
  end

  def destroy
    @bot.intent.delete(@pattern.trigger)
    @bot.save
    @pattern.destroy
    redirect_to edit_bot_path(@bot, active: :patterns)
  end

  private
    def set_pattern
      @pattern = Pattern.find(params[:id])
    end

    def find_bot
      @bot = Bot.find(params[:bot_id])
    end

    def pattern_params
      params.require(:pattern).permit(:trigger, :answer)
    end
end
