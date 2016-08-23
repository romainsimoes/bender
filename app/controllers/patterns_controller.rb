class PatternsController < ApplicationController
  before_action :set_pattern, only: [:show, :edit, :update, :destroy]
  before_action :find_bot, only: [:new, :edit, :create, :update, :destroy]
  skip_after_action :verify_authorized

  def index
    @patterns = Pattern.all
  end

  def new
    @pattern = Pattern.new
  end

  def edit
  end

  def create
    @pattern = Pattern.new(pattern_params)
    @pattern.bot_id = @bot.id
    if @pattern.save
      redirect_to bot_path(@bot), notice: 'Pattern was successfully created.'
    else
      render :new
    end
  end

  def update
    if @pattern.update(pattern_params)
      redirect_to bot_path(@bot), notice: 'Pattern was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @pattern.destroy
    redirect_to bot_path(@bot), notice: 'Pattern was successfully destroyed.'
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
