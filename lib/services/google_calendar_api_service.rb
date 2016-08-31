require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

class GoogleCalendarServiceUserNotGoogleConnectedError < StandardError
end

class GoogleCalendarApiService

  def self.get_authorization(user)
    # User not connected to Google initialization errors
    if(user.is_user_google_connected?)
      raise GoogleCalendarServiceUserNotGoogleConnectedError, "User don't have token or google mail"
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

end
