class SharedJob < ProcessBotMessageJob

  def self.send_and_store_answer(answer, pattern_id)
    FacebookRequestService.send_message(@@message_sender_id, answer, @@bot)
    History.create(question: @@message_text, answer: answer, bot_id: @@bot.id, pattern_id: pattern_id)
    @@return = true
  end

  def self.send_and_store_quick_answer(answer, pattern_id)
    FacebookRequestService.quick_replies(@@message_sender_id, answer, @@bot)
    History.create(question: @@message_text, answer: answer, bot_id: @@bot.id, pattern_id: pattern_id)
    @@return = true
  end

  def self.send_map
    FacebookRequestService.map_template(@@message_sender_id, @@bot)
    @@return = true
  end

  def self.send_item_template
    FacebookRequestService.item_template(@@message_sender_id, @@bot)
    @@return = true
  end

  def self.stepper(step_request)
    @@session_retreiver.step = step_request
    @@session_retreiver.save
  end

  def self.date_parser(date_to_format)
    date_matches = date_to_format.scan(/(\d{2})-(\d{2})-(\d{2})T(\d{2}:\d{2})/)
    date_matches.first
  end


  def self.send_confirmed_order(answer, pattern_id)
    FacebookRequestService.send_message(@@message_sender_id, answer, @@bot)
    FacebookRequestService.send_receipt_template(@@message_sender_id, @@bot, @@products, @@address)
    product = @@products.join(" ")
    Order.create(product: product, address: @@address, bot_id: @@bot.id, status: "en cours", sender_id: @@message_sender_id)
  end

  def self.create_google_agenda_event(event)
    GoogleCalendarApiService.create_event(@@bot.user, event)
  end

  def self.get_list_of_google_event
    GoogleCalendarApiService.get_events(@@bot.user)
  end

  def self.create_event_with_date(date)
    event_start = DateTime.parse(date)
    event_end = event_start + (30/1440.0)
    event = {
      summary: 'Booking',
      start: {
        date_time: date,
        time_zone: "Europe/Paris",
      },
      end: {
        date_time: event_end.iso8601,
        time_zone: "Europe/Paris",
      },
    }
  end

  def self.create_event_to_check_with_date(date)
    event_start = DateTime.parse(date)
    event_end_to_format = event_start + (30/1440.0)
    event_end = event_end_to_format.iso8601
    event = {
      time_min: date,
      time_max: event_end,
      time_zone: "Europe/Paris"
    }
  end

  def self.is_the_slot_busy?(event)
    GoogleCalendarApiService.busy?(@@bot.user, event)
  end

  def self.format_dates(hour, date)
    "20#{date[2]}-#{date[1]}-#{date[0]}T#{hour}:00.000+02:00"
  end

  def self.make_an_order
    FacebookRequestService.item_template(@@message_sender_id, @@bot)
    @@return = true
  end
end
