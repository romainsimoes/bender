class ProcessBotMessageJob < ApplicationJob
  queue_as :default


  def perform(message_sender_id, message_text, bot)
    session_recovering(message_sender_id)
    var_initalizer(message_sender_id, message_text, bot)

    get_intent

    step_path unless @step == 'start'
    return if @return

    intent_path
    return if @return

    text_pattern
    return if @return

    no_matches
  end

  def step_path
    case @step
    when 'booking_boolean'
      booking_boolean_step
      return
    when 'date_asked'
      date_asked_step
      return
    when 'what_next'
      what_next_step
      return
    end
  end

  def intent_path
    case @intent
      when "wit_stop_all"
        wit_stop_all_path
      when "wit_opening_times"
        if @bot.wit_opening_times
          intent_pattern
          wit_opening_times_path
          return
        end
      when 'agenda_entry'
        if @bot.wit_booking
          wit_agenda_entry_path
          return
        end
      when 'wit_welcome'
        if @bot.wit_welcome
          intent_pattern
          return
        end
    end
  end

  def wit_stop_all_path
    send_and_store_answer(@negative_message, nil)
    @return = true
    stepper('start')
  end

  def booking_boolean_step
    if @message_text == 'Oui'
      send_and_store_answer(@ask_for_date_message, nil)
      stepper('date_asked')
      @return = true
    elsif @message_text == 'Non'
      send_and_store_answer(@negative_message, nil)
      stepper('what_next')
      @return = true
    end
  end

  def date_asked_step
    entities = WitApiService.get_date(@message_text)
    p entities
    if entities['datetime'][0]['value'] && (entities['datetime'][0]['confidence'] > 0.93)
      booking_request = entities['datetime'][0]['value']
      date_matches = date_parser(booking_request)
      validation_message = "C'est réservé pour le #{date_matches[2]}/#{date_matches[1]}/#{date_matches[0]} à #{date_matches[3]}"
      send_and_store_answer(validation_message, nil)
      send_and_store_answer(@ask_what_next_message, nil)
      stepper('what_next')
      @return = true
    end
  end

  def what_next_step
    if @intent == 'wit_positive'
      send_and_store_answer(@positive_message, nil)
      @return = true
      stepper('start')
    elsif @intent == 'wit_negative'
      send_and_store_answer(@negative_message, nil)
      @return = true
      stepper('start')
    end
  end

  def wit_opening_times_path
    send_and_store_quick_answer(@booking_message, nil)
    if @bot.wit_booking
      stepper('booking_boolean')
    end
  end

  def wit_agenda_entry_path
    ask_for_date = 'Quand Souhaitez-vous réserver ?'
    send_and_store_answer(@ask_for_date_message, nil)
    stepper('date_asked')
  end





  def what_next
    send_and_store_answer(@ask_what_next_message, nil)
    stepper('what_next')
  end


  def date_parser(date_to_format)
    date_matches = date_to_format.scan(/(\d{2})-(\d{2})-(\d{2})T(\d{2}:\d{2})/)
    date_matches.first
  end

  def intent_pattern
    answer_pattern = @bot.match_intent_pattern(@entities) if @entities
    if answer_pattern
      pattern_id = answer_pattern[:pattern_id]
      answer = answer_pattern[:answer]
    end

    send_and_store_answer(answer, pattern_id) if answer
  end

  def text_pattern
    answer_pattern = @bot.match_text_pattern(@message_text)
    if answer_pattern
      answer = answer_pattern[:answer]
      pattern_id = answer_pattern[:pattern_id]
    end

    if answer
      send_and_store_answer(answer, pattern_id)
      @return = true
    end
  end

  def send_and_store_answer(answer, pattern_id)
    FacebookRequestService.send_message(@message_sender_id, answer, @bot.page_access_token)
    History.create(question: @message_text, answer: answer, bot_id: @bot.id, pattern_id: pattern_id)
    @return = true
  end

  def send_and_store_quick_answer(answer, pattern_id)
    FacebookRequestService.quick_replies(@message_sender_id, answer, @bot.page_access_token)
    History.create(question: @message_text, answer: answer, bot_id: @bot.id, pattern_id: pattern_id)
    @return = true
  end

  def no_matches
    answer = "J'ai rien compris batard"
    send_and_store_answer(answer, nil)
  end

  def var_initalizer(message_sender_id, message_text, bot)
    @message_sender_id = message_sender_id
    @message_text = message_text
    @bot = bot
    @step = @session_retreiver.step
    @return = false
    @ask_what_next_message = "Puis-je vous aider pour quelque chose d'autre ?"
    @positive_message = "Comment puis-je vous aider ?"
    @negative_message = "Pas de soucis, n'hésitez pas à me recontacter plus tard"
    @booking_message = "Souhaitez-vous prendre un RDV ?"
    @ask_for_date_message = 'Quand Souhaitez-vous réserver ?'
  end

  def stepper(step_request)
    @session_retreiver.step = step_request
    @session_retreiver.save
  end

  def get_intent
    @entities = WitApiService.get_entities(@message_text)
    @intent = @entities.keys[0] if @entities
  end

  def session_recovering(message_sender_id)
    recovery = Recovery.where(sender_id: message_sender_id)
    if recovery.empty?
      @session_retreiver = Recovery.new(sender_id: message_sender_id, step: "start")
    elsif recovery.first.outdated?
      @session_retreiver = Recovery.new(sender_id: message_sender_id, step: "start")
    else
      @session_retreiver = recovery.first
    end
  end

end

