class ProcessBotMessageJob < ApplicationJob
  queue_as :default


  def perform(message_sender_id, message_text, bot)


    entities = WitApiService.get_entities(message_text)

    answer_intent = bot.match_intent_pattern(entities) if entities

    if answer_intent
      answer = answer_intent[:answer]
      intent = answer_intent[:intent]
    end

    answer = bot.match_text_pattern(message_text) unless answer

    answer = "J'ai rien compris batard" unless answer

    FacebookRequestService.send_message(message_sender_id, answer, bot.page_access_token)
    # 3 enregistrer dans history

  end

end

