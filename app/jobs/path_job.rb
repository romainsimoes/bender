class PathJob < ProcessBotMessageJob

  def self.wit_stop_all_path
    SharedJob.send_and_store_answer(@@negative_message, nil)
    SharedJob.stepper('start')
    @@return = true
  end

  def self.wit_opening_times_path
    SharedJob.send_and_store_quick_answer(@@booking_message, nil)
    if @@bot.intent.include?('agenda_entry')
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

end
