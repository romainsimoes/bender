module HistoriesHelper

  def pattern_number(bot_id)
    #History.all.where(bot: Bot.find(bot_id)).group(:pattern_id).count
    {nil=>1, nil=>2, nil=>1}
  end

  def defaultmessage(bot)
    defaultmessage = 0
    bot.histories.each do | history |
      if history.pattern.nil?
        defaultmessage += 1
      end
    end
    return defaultmessage
  end

  def successfull_answers_percentage(bot)
    return 0 unless bot.histories.size > 0
    (bot.histories.size - defaultmessage(bot)) * 100 / bot.histories.size
  end

end
