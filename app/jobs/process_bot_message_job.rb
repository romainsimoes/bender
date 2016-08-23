class ProcessBotMessageJob < ApplicationJob
  queue_as :default

  def perform(message_sender_id, message_text, bot)

    # 1 utiliser bot + message pour essayer de trouver la réponse
    message = bot.match_pattern(message_text)

    unless message
      message = "default message"
    end

    # 2 si il y a une réponse envoyer la réponse
    FacebookRequestService.send_message(message_sender_id, message, bot.page_access_token)
    # 3 enregistrer dans history

  end
end
