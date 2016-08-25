class ProcessBotMessageJob < ApplicationJob
  queue_as :default


  def perform(message_sender_id, message_text, bot)

    session_recovering(message_sender_id)

    starting_step(message_sender_id, message_text, bot) if @session_retreiver.step == 'start'

    case @intent
    when "wit_opening_times"
      booking_message = "Souhaitez-vous reserver un RDV ?"
      FacebookRequestService.quick_replies(message_sender_id, booking_message, bot.page_access_token)
      @session_retreiver.step = 'booking_boolean'
      @session_retreiver.save
      return
    when 'wit_booking'
      @session_retreiver.step = 'booking_boolean'
      @session_retreiver.save
    end

    case @session_retreiver.step
    when 'booking_boolean'
      if message_text == 'Oui'
        ask_for_date = 'Quand Souhaitez-vous réserver ?'
        FacebookRequestService.send_message(message_sender_id, ask_for_date, bot.page_access_token)
        @session_retreiver.step = 'date_asked'
        @session_retreiver.save
      else
        ask_what_next = "Puis-je vous aider pour quelque chose d'autre ?"
        FacebookRequestService.send_message(message_sender_id, ask_what_next, bot.page_access_token)
        @session_retreiver.destroy
      end
    when 'date_asked'
      entities = WitApiService.get_date(message_text)
      p entities
      FacebookRequestService.send_message(message_sender_id, "C'est réservé !!", bot.page_access_token)
      ask_what_next = "Puis-je vous aider pour quelque chose d'autre ?"
      FacebookRequestService.send_message(message_sender_id, ask_what_next, bot.page_access_token)
      @session_retreiver.destroy
    end
  end


  def session_recovering(message_sender_id)
    recovery = Recovery.where(sender_id: message_sender_id)
    if recovery.empty?
      @session_retreiver = Recovery.new(sender_id: message_sender_id, step: "start")
    else
      @session_retreiver = recovery.first
    end
  end


  def starting_step(message_sender_id, message_text, bot)
    entities = WitApiService.get_entities(message_text)
    answer_intent = bot.match_intent_pattern(entities) if entities

    if answer_intent
      answer = answer_intent[:answer]
      @intent = answer_intent[:intent]
    end

    answer = bot.match_text_pattern(message_text) unless answer
    answer = "J'ai rien compris batard" unless answer

    FacebookRequestService.send_message(message_sender_id, answer, bot.page_access_token)
  end

end

