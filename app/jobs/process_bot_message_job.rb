class ProcessBotMessageJob < ApplicationJob
  queue_as :default

  def perform(message_sender_id, message_text, bot)
    # TODO : do something

    p message_sender_id
    p message_text
    p bot


    # 1 utiliser bot + message pour essayer de trouve la réponse

    # 2 si il y a une réponse envoyer la réponse
    FacebookRequestService.send_message(message_sender_id, 'bonjour :)', 'EAAOSnZA1FWRkBAHBTLbmrAyZAlrmrwGMnP1ZCKNwGK2p2l8Wqc5ZBX6VvByOwxHKLY1bRQGPf5ybLUaiDR5tPFDDB5DTkoOEodJaKr3doN7kwAbK1r00UwolU5KUYTP6O4UvShKQHWDKg4fZAOznnZBRjceeDRdI37c5G5ClhZBQwZDZD')
    # 3 enregistrer dans history
  end
end
