class ProcessBotMessageJob < ApplicationJob
  queue_as :default

  def perform(message_sender_id, message_text, bot)
    # TODO : do something

    p message_sender_id
    p message_text
    p bot


    # 1 utiliser bot + message pour essayer de trouve la réponse

    # 2 si il y a une réponse envoyer la réponse
    FacebookRequestService.send_message(message_sender_id, 'bonjour :)', 'TOKEN')
    # 3 enregistrer dans history
  end
end