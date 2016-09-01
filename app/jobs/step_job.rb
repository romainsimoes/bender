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
    entities = WitApiService.get_date(@@message_text)
    if entities.key?('datetime')
      if entities['datetime'][0]['value'] && (entities['datetime'][0]['confidence'] > 0.9)
        @@date ||= nil
        booking_request = entities['datetime'][0]['value']
        date_matches = SharedJob.date_parser(booking_request)
        if date_matches[3] != '00:00'
          if @@date
            if match_request_with_opening_times?(date_matches)
              validation_message = "C'est réservé pour le #{@@date} à #{date_matches[3]}"
              SharedJob.send_and_store_answer(validation_message, nil)
              SharedJob.send_and_store_answer(@@ask_what_next_message, nil)
              SharedJob.stepper('what_next')
            else
              SharedJob.send_and_store_answer(@@sorry_not_available, nil)
            end
          else
            if match_request_with_opening_times?(date_matches)
              validation_message = "C'est réservé pour le #{date_matches[2]}/#{date_matches[1]}/#{date_matches[0]} à #{date_matches[3]}"
              SharedJob.send_and_store_answer(validation_message, nil)
              SharedJob.send_and_store_answer(@@ask_what_next_message, nil)
              SharedJob.stepper('what_next')
            else
              SharedJob.send_and_store_answer(@@sorry_not_available, nil)
            end
          end
          @@return = true
        else
          @@date = [date_matches[2], date_matches[1], date_matches[0]]
          ask_for_time_step_one = "Pas de soucis pour le #{@@date[0]}/#{@@date[1]}/#{@@date[2]}, nos disponibilités ce jour-ci sont:"
          SharedJob.send_and_store_answer(ask_for_time_step_one, nil)
          SharedJob.send_and_store_answer(@@ask_for_time_step_three, nil)
          @@return = true
        end
      end
    end
  end

  def self.match_request_with_opening_times?(date_matches)
    if @@bot.info
      day_conversion = { 'Sun' => 0, 'Mon' => 1, 'Tue' => 2, 'Wed' => 3, 'Thr' => 4, 'Fri' => 5, 'Sat' => 6 }
      if @@date
        day = Date::ABBR_DAYNAMES[Date.parse("20#{@@date[2]}/#{@@date[1]}/#{@@date[0]}", '%Y-%m-%d').wday]
        day_number = day_conversion[day]
      else
        day = Date::ABBR_DAYNAMES[Date.parse("20#{date_matches[0]}/#{date_matches[1]}/#{date_matches[2]}", '%Y-%m-%d').wday]
        day_number = day_conversion[day]
      end
      opening_and_closing = []

      @@bot.info['result']['opening_hours']['periods'].each do |hash|
        right_day = false
        hash.each do |_, v|
          right_day = v.has_value?(day_number)
        end
        opening_and_closing << hash if right_day
      end

      date_json_format = date_matches[3].gsub(/:/, '').to_i
      opening_and_closing.each do |a|
        if (a['open']['time'].to_i < date_json_format) && (a['close']['time'].to_i > date_json_format)
          p 'YAHA'
          return true
        end
      end
      false
    else
      true
    end
  end

  def self.match_request_with_availabities(date_matches)
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

  def self.ordering_step
    @@products << @@message_text
    p @@products
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
