class PathJob < ProcessBotMessageJob

  def self.wit_stop_all_path
    SharedJob.send_and_store_answer(@@negative_message, nil)
    SharedJob.stepper('start')
    @@return = true
  end

  def self.wit_opening_times_path
    if @@bot.intent.include?('agenda_entry')
      SharedJob.send_and_store_quick_answer(@@booking_message, nil)
      SharedJob.stepper('booking_boolean')
    end
  end

  def self.agenda_entry_path
    SharedJob.send_and_store_answer(@@ask_for_date_message, nil)
    SharedJob.stepper('date_asked')
  end

  def self.wit_polite_path
    SharedJob.send_and_store_answer(@@thanks_message, nil)
  end

  def self.location_path
    SharedJob.send_map
  end

  def self.wit_order_path
    SharedJob.send_and_store_answer(@@make_an_order_message, nil)
    SharedJob.send_item_template
    SharedJob.stepper('ordering')
  end

  def self.wit_website_path
    SharedJob.send_and_store_answer(@@website, nil)
    @@return = true
  end

  def self.wit_tel_path
    SharedJob.send_and_store_answer(@@telephone, nil)
    @@return = true
  end

end
