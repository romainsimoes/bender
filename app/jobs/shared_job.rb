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

  def self.stepper(step_request)
    @@session_retreiver.step = step_request
    @@session_retreiver.save
  end

  def self.date_parser(date_to_format)
    date_matches = date_to_format.scan(/(\d{2})-(\d{2})-(\d{2})T(\d{2}:\d{2})/)
    date_matches.first
  end

end
