class StepJob < ProcessBotMessageJob

  def self.booking_boolean_step
    if @@message_text == 'Oui'
      SharedJob.send_and_store_answer(@@ask_for_date_message, nil)
      SharedJob.stepper('date_asked')
      @@return = true
    elsif @@message_text == 'Non'
      SharedJob.send_and_store_answer(@@negative_message, nil)
      SharedJob.stepper('what_next')
      @@return = true
    end
  end

  def self.date_asked_step
    entities = WitApiService.get_date(@@message_text)
    if entities.key?('datetime')
      if entities['datetime'][0]['value'] && (entities['datetime'][0]['confidence'] > 0.93)
        booking_request = entities['datetime'][0]['value']
        date_matches = SharedJob.date_parser(booking_request)
        validation_message = "C'est réservé pour le #{date_matches[2]}/#{date_matches[1]}/#{date_matches[0]} à #{date_matches[3]}"
        SharedJob.send_and_store_answer(validation_message, nil)
        SharedJob.send_and_store_answer(@@ask_what_next_message, nil)
        SharedJob.stepper('what_next')
        @@return = true
      end
    end
  end

  def self.what_next_step
    if @@intent == 'wit_positive'
      SharedJob.send_and_store_answer(@@positive_message, nil)
      SharedJob.stepper('start')
      @@return = true
    elsif @@intent == 'wit_negative'
      SharedJob.send_and_store_answer(@@negative_message, nil)
      SharedJob.stepper('start')
      @@return = true
    end
  end

end
