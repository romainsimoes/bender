class StepJob < ProcessBotMessageJob

  def self.booking_boolean_step
    if @@message_text == 'Oui'
      SharedJob.send_and_store_answer(@@ask_for_date_message, nil)
      SharedJob.stepper('date_asked')
      @@return = true
    elsif @@message_text == 'Non'
      SharedJob.send_and_store_answer(@@negative_message, nil)
      SharedJob.stepper('start')
      @@return = true
    end
  end

  def self.date_asked_step
    GoogleAgendaManagementJob.date_creator
  end

  def self.what_next_step
    if @@intent == 'wit_positive'
      SharedJob.send_and_store_answer(@@positive_message, nil)
    elsif @@intent == 'wit_negative'
      SharedJob.send_and_store_answer(@@negative_message, nil)
    end
    SharedJob.stepper('start')
    @@return = true
  end

  def self.ordering_step
    @@products << @@message_text
    SharedJob.send_and_store_quick_answer(@@ask_for_more_message, nil)
    SharedJob.stepper('order_more')
    @@return = true
  end

  def self.order_more_step
    if @@message_text == 'Non'
      SharedJob.send_item_template
      SharedJob.stepper('ordering')
      @@return = true
    elsif @@message_text == 'Oui'
      SharedJob.send_and_store_quick_answer(@@ask_to_confirm_order_message, nil)
      SharedJob.stepper('confirm_order')
      @@return = true
    end
  end

  def self.address_step
    @@address = @@message_text
    SharedJob.send_confirmed_order(@@order_confirmed_message, nil)
    SharedJob.stepper('start')
    @@products = []
    @@return = true
  end

  def self.confirm_order_step
    if @@message_text == 'Oui'
      SharedJob.send_and_store_answer(@@ask_for_address_message, nil)
      SharedJob.stepper('address')
      @@return = true
    elsif @@message_text == 'Non'
      SharedJob.send_and_store_answer(@@negative_message, nil)
      SharedJob.stepper('start')
      @@products = []
      @@return = true
    end
  end
end
