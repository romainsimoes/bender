require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

class GoogleCalendarApiService

  def self.create_event(user)
    user.refresh_token_if_expired

    authorization = Google::Auth::UserRefreshCredentials.new(
        client_id: ENV['GOOGLE_CALENDAR_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CALENDAR_CLIENT_SECRET'],
        scope: 'https://www.googleapis.com/auth/calendar',
        access_token: user.google_token,
        refresh_token: user.refresh_token,
        expires_at: user.expires_at,
        grant_type: 'authorization_code')


    @@event = {
      'summary' => 'New Event Title',
      'description' => 'The description',
      'location' => 'Location',
      'start' => { 'dateTime' => Chronic.parse('tomorrow 4 pm') },
      'end' => { 'dateTime' => Chronic.parse('tomorrow 5pm') },
      'attendees' => [ { "email" => 'bob@example.com' },
      { "email" =>'sally@example.com' } ] }


    client = Google::Apis::CalendarV3::CalendarService.new

    client.key = "AIzaSyC2EggZa1BTpxMAqzR-Ratmi6TrFuoKekM"
    #client = Google::APIClient.new
    client.authorization = authorization
    #service = client.discovered_api('calendar', 'v3')
    client.list_events(user.google_email) do |res, err|
      if err
        puts 'coucou'
        puts err.body
      end
      puts res.body
    end

    # @@set_event = client.execute(:api_method => service.events.insert,
    #                         :parameters => {'calendarId' => user.google_email, 'sendNotifications' => true},
    #                         :body => JSON.dump(@@event),
    #                         :headers => {'Content-Type' => 'application/json'})
  end

end
