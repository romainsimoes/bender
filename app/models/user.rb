class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many :bots

  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)

    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    return user
  end

  def self.find_for_google_oauth2(access_token, user)

    # Get information
    user.expires_at = access_token.credentials.expires_at
    user.refresh_token = access_token.credentials.refresh_token unless user.refresh_token
    user.google_token = access_token.credentials.token

    # Verify informations
    if user.is_user_google_connected?
      user.save
      user
    else
      print 'Error when get google information for user with id : ' + user.id.to_s
      nil
    end
  end

  def refresh_token_if_expired
    if token_expired?
      response = RestClient.post(
          'https://accounts.google.com/o/oauth2/token',
          :grant_type => 'refresh_token',
          :refresh_token => self.refresh_token,
          :client_id => ENV['GOOGLE_CALENDAR_CLIENT_ID'],
          :client_secret => ENV['GOOGLE_CALENDAR_CLIENT_SECRET']
        )

      refreshhash = JSON.parse(response.body)

      self.google_token     = refreshhash['access_token']
      self.expires_at = DateTime.now + refreshhash["expires_in"].to_i.seconds

      self.save
    end
  end

  def token_expired?
    expiry = Time.at(self.expires_at)
    return true if expiry < Time.now
    false
  end

  def admin?
    true
  end

  def is_user_google_connected?
    google_token.nil? || refresh_token.nil?
  end
end
