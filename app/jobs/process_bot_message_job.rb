class ProcessBotMessageJob < ApplicationJob
  queue_as :default

  def perform(message_sender_id, message_text, bot)

    # 1 utiliser bot + message pour essayer de trouver la réponse
<<<<<<< HEAD
    hash = bot.match_pattern(message_text)
    message = hash[:answer]
    pattern = hash[:pattern]
=======
    message = bot.match_pattern(message_text)
>>>>>>> 981c1a300ab59a08ad03aa5b0882b484601eec36

    unless message
      message = "default message"
    end

    # 2 si il y a une réponse envoyer la réponse
    FacebookRequestService.send_message(message_sender_id, message, bot.page_access_token)
    # 3 enregistrer dans history

    History.create(question: message_text, answer: message, bot_id: bot, pattern_id: pattern )

  end
end
