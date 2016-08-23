require 'rest-client'

class FacebookRequestService


  def self.subscribe(page_token)
    app_location = "https://graph.facebook.com/v2.6/me/subscribed_apps?access_token=#{page_token}"
    RestClient.post(app_location, nil)
  end

  def self.send_message(recipient_id, message_text, page_token)
    p message_text

    message_data = {
        recipient: {
          id: recipient_id
        },
        message: {
          text: message_text
        }
      }

    RestClient.post(
        "https://graph.facebook.com/v2.6/me/messages?access_token=#{page_token}",
        message_data.to_json,
        content_type: :json
      )
  end

  def self.get_profile(recipient_id)
  end


  def call_send_API(message_data, page_token)

    # rescue RestClient::ExceptionWithResponse => err
    #   puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    # end
  end

end
