class HistoriesController < ApplicationController
before_action :set_bot, only: [:index]
skip_after_action :verify_authorized

  def index
    @histories =  policy_scope(History)
    defaultmessage
    @pattern_number = History.all.where(bot: Bot.find(params[:bot_id])).group(:pattern_id).count
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot
    end

    def defaultmessage
      @defaultmessage = 0
      @bot.histories.each do | history |
        if history.pattern.nil?
          @defaultmessage += 1
        end
      end
    end
end
