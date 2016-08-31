class SharedJob < ProcessBotMessageJob

  def self.send_and_store_answer(answer, pattern_id)
    FacebookRequestService.send_message(@@message_sender_id, answer, @@bot.page_access_token)
    History.create(question: @@message_text, answer: answer, bot_id: @@bot.id, pattern_id: pattern_id)
    @@return = true
  end

  def self.send_and_store_quick_answer(answer, pattern_id)
    FacebookRequestService.quick_replies(@@message_sender_id, answer, @@bot.page_access_token)
    History.create(question: @@message_text, answer: answer, bot_id: @@bot.id, pattern_id: pattern_id)
    @@return = true
  end

  def self.send_map
    FacebookRequestService.map_template(@@message_sender_id, @@bot)
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

  def self.create_google_agenda_event(event)
    GoogleCalendarApiService.create_event(@@bot.user, event)
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

  def self.format_dates(hour, date)
    "20#{date[2]}-#{date[1]}-#{date[0]}T#{hour}:00.000+02:00"
  end

end
