class ProcessBotMessageJob < ApplicationJob
  queue_as :default


  def perform(message_sender_id, message_text, bot)
    session_recovering(message_sender_id, bot)
    var_initializer(message_sender_id, message_text, bot)

    get_intent

    step_path unless @@step == 'start'
    return if @@return

    text_matcher
    return if @@return

    intent_path
    return if @@return

    no_matches
  end

  def step_path
    StepJob.send(@@step + '_step') if StepJob.respond_to? (@@step + '_step').to_sym
  end

  def intent_path
    if @@bot.intents.where(name: 'wit_welcome').first
      intent_check
      if PathJob.respond_to? (@@intent + '_path').to_sym
        PathJob.send(@@intent + '_path')
      end
    end
  end

  def intent_check
    answer_intent = @@bot.match_intent(@@entities) if @@entities
    if answer_intent
      intent_id = answer_intent[:intent_id]
      answer = answer_intent[:answer]
    end
    SharedJob.send_and_store_answer(answer, intent_id) if answer
  end

  def text_matcher
    answer_pattern = @@bot.match_pattern(@@message_text)
    if answer_pattern
      answer = answer_pattern[:answer]
      pattern_id = answer_pattern[:pattern_id]
    end

    if answer
      SharedJob.send_and_store_answer(answer, pattern_id)
      @@return = true
    end
  end

  def no_matches
    answer = "Ne m'en demande pas trop, je ne suis qu'un robot"
    SharedJob.send_and_store_answer(answer, nil)
  end

  def var_initializer(message_sender_id, message_text, bot)
    @@message_sender_id = message_sender_id
    @@message_text = message_text
    @@bot = bot
    @@step = @@session_retreiver.step
    @@return = false
    @@ask_what_next_message = "Puis-je vous aider pour quelque chose d'autre ?"
    @@positive_message = "Comment puis-je vous aider ?"
    @@negative_message = "Pas de soucis, n'hésitez pas à me recontacter plus tard"
    @@booking_message = "Souhaitez-vous prendre un RDV ?"
    @@ask_for_date_message = 'Quand Souhaitez-vous réserver ?'
    @@thanks_message = 'Tout le plaisir est pour moi'
    @@ask_for_time_step_three = 'A quelle heure souhaitez-vous réserver ?'
    @@sorry_not_available = 'Désolé, nous sommes fermés à cette heure là, veuillez choisir une autre horaire'
    @@make_an_order_message = "Que voulez-vous commandez ?"
    @@ask_to_confirm_order_message = "Voulez-vous confirmez votre commande"
    @@ask_for_more_message = "Ce sera tout ?"
    @@ask_for_address_message = "Quelle est votre addresse"
    @@ask_something_message = "Que souhaiteriez-vous ?"
    @@products = [] unless defined?(@@products)
    @@address = ""
    @@order_confirmed_message = "Votre commande est bien confirmée! Voici un récapitulatif"
    @@bot.info ? @@website = @@bot.info['result']['website'] : @@website = "Désolé, je ne connais pas l'url"
    @@bot.info ? @@telephone = @@bot.info['result']['international_phone_number'] : @@telephone = "Désolé, je ne connais pas le numéro"
  end

  def get_intent
    @@entities = WitApiService.get_entities(@@message_text)
    @@entities ? @@intent = @@entities.keys[0] : @@intent = nil
  end

  def session_recovering(message_sender_id, bot)
    recovery = Recovery.where(sender_id: message_sender_id)
    if recovery.empty?
      @@session_retreiver = Recovery.new(sender_id: message_sender_id, step: "start", bot_id: bot.id)
      @@session_retreiver.save
    elsif recovery.first.outdated?
      @@session_retreiver = recovery.first
      SharedJob.stepper('start')
    else
      @@session_retreiver = recovery.first
    end
  end

end

