class GoogleCalendarApiService

  def self.initialize_cal
    @@cal = Google::Calendar.new(:client_id     => ENV['GOOGLE_CALENDAR_CLIENT_ID'],
        :client_secret => ENV['GOOGLE_CALENDAR_CLIENT_SECRET'],
        :calendar      => 'romain.simoes.pro@gmail.com',
        :redirect_url  => "urn:ietf:wg:oauth:2.0:oob" # this is what Google uses for 'applications'
      )

    # p @@cal.authorize_url
    # p "\nCopy the code that Google returned and paste it here:"

    #   # Pass the ONE TIME USE access code here to login and get a refresh token that you can use for access from now on.
    #   refresh_token = @@cal.login_with_auth_code( $stdin.gets.chomp )

    #   puts "\nMake sure you SAVE YOUR REFRESH TOKEN so you don't have to prompt the user to approve access again."
    #   puts "your refresh token is:\n\t#{refresh_token}\n"
    #   puts "Press return to continue"
    #   $stdin.gets.chomp
  end

  def self.create_event
    event = @@cal.create_event do |e|
      e.title = 'A Cool Event'
      e.start_time = Time.now
      e.end_time = Time.now + (60 * 60) # seconds * min
    end
  end
end
