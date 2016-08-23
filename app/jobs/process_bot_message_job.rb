class ProcessBotMessageJob < ApplicationJob
  queue_as :default

  def perform(message_sender_id, message_text, bot)
    # TODO : do something

    p message_sender_id
    p message_text
    p bot


    # 1 utiliser bot + message pour essayer de trouve la réponse

    # 2 si il y a une réponse envoyer la réponse
    FacebookRequestService.send_message(message_sender_id, 'bonjour :)', 'EAASrII2HfC0BAAyCOXt1TtcliQCyUH0W6PGCpiDIaolk8un3UV22wBeqwyZBsZAlgVbZB9z5Bn3vlZAOhedrY7sS4U3lX5gz929ot7nAQ9RwYHZBQEYFZAPLfQ9FxgWQrZABnAWzKPwTegk9OhQy9y7Vu80wlr5b98Nkc5b64a41QZDZD')


    # 3 enregistrer dans history
  end
end
