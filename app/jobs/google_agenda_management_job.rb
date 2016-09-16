class GoogleAgendaManagementJob < ProcessBotMessageJob

  def self.date_creator
   entities = WitApiService.get_date(@@message_text)
    unless entities.empty?
      if entities.key?('datetime')
        if entities['datetime'][0]['value'] && (entities['datetime'][0]['confidence'] > 0.9)
          date_creation_process(entities)
        end
      end
    end
  end

  def self.date_creation_process(entities)
    @@date ||= nil
    booking_request = entities['datetime'][0]['value']
    date_matches = SharedJob.date_parser(booking_request)
    if date_matches[3] != '00:00'
      if @@date
        if match_request_with_opening_times?(date_matches)
          validation_message = "C'est réservé pour le #{@@date[0]}/#{@@date[1]}/#{@@date[2]} à #{date_matches[3]}"
          SharedJob.send_and_store_answer(validation_message, nil)
          SharedJob.send_and_store_answer(@@ask_what_next_message, nil)
          date_formatted = SharedJob.format_dates(date_matches[3], @@date)
          event = SharedJob.create_event_with_date(date_formatted)
          SharedJob.create_google_agenda_event(event)
          SharedJob.stepper('what_next')
        else
          SharedJob.send_and_store_answer(@@sorry_not_available, nil)
        end
      else
        if match_request_with_opening_times?(date_matches)
          p '#######'
          event_to_check = SharedJob.create_event_to_check_with_date(booking_request)
          if SharedJob.is_the_slot_busy?(event_to_check)
            @@return = true
            SharedJob.send_and_store_answer('déso c pas dispo', nil)
            return
          end
          p '#######'
          validation_message = "C'est réservé pour le #{date_matches[2]}/#{date_matches[1]}/#{date_matches[0]} à #{date_matches[3]}"
          SharedJob.send_and_store_answer(validation_message, nil)
          SharedJob.send_and_store_answer(@@ask_what_next_message, nil)
          event = SharedJob.create_event_with_date(booking_request)
          SharedJob.create_google_agenda_event(event)
          SharedJob.stepper('what_next')
        else
          SharedJob.send_and_store_answer(@@sorry_not_available, nil)
        end
      end
      @@return = true
    else
      @@date = [date_matches[2], date_matches[1], date_matches[0]]
      ask_for_time_step_one = "Pas de soucis pour le #{@@date[0]}/#{@@date[1]}/#{@@date[2]}"
      SharedJob.send_and_store_answer(ask_for_time_step_one, nil)
      SharedJob.send_and_store_answer(@@ask_for_time_step_three, nil)
      @@return = true
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
          return true
        end
      end
      false
    else
      true
    end
  end
end
