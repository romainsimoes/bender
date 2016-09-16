require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

class GoogleCalendarServiceUserNotGoogleConnectedError < StandardError
end

class GoogleCalendarApiService

  def self.get_authorization(user)
    # User not connected to Google initialization errors
    unless (user.is_user_google_connected?)
      raise GoogleCalendarServiceUserNotGoogleConnectedError, "User don't have google token or refresh token"
    end

    user.refresh_token_if_expired

    authorization = Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['GOOGLE_CALENDAR_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CALENDAR_CLIENT_SECRET'],
      scope: 'https://www.googleapis.com/auth/calendar',
      access_token: user.google_token,
      refresh_token: user.refresh_token,
      expires_at: user.expires_at,
      grant_type: 'authorization_code'
    )
  end

  def self.create_event(user, event)

    authorization = get_authorization(user)

    google_event = Google::Apis::CalendarV3::Event.new(event)
    client = Google::Apis::CalendarV3::CalendarService.new

    client.authorization = authorization

    result = client.insert_event('primary', google_event)

    # puts "Event created: #{result.html_link}"
  end

  def self.busy?(user, event)
    p 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
    p event
    p 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'

    authorization = get_authorization(user)

    google_event = Google::Apis::CalendarV3::FreeBusyRequest.new
    google_event.time_min = event[:time_min]
    google_event.time_max = event[:time_max]
    google_event.time_zone = event[:time_zone]
    google_event.items = [{id: "primary"}]

    p '@@@@@@@@@@@@@@@@@@@@@@@@@@@'
    p google_event
    p '@@@@@@@@@@@@@@@@@@@@@@@@@@@'

    client = Google::Apis::CalendarV3::CalendarService.new

    client.authorization = authorization

    result = client.query_freebusy(google_event)

    p result

    result.calendars['primary'].busy.empty? ? false : true
  end

end
