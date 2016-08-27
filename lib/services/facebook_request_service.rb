class FacebookRequestService

  def self.subscribe(page_token)
    app_location = "https://graph.facebook.com/v2.6/me/subscribed_apps?access_token=#{page_token}"
    data = RestClient.post(app_location, nil)
    json = JSON.parse(data)
    json['success'] # return true if success, false otherwise
  end

  def self.send_message(recipient_id, message_text, page_token)
    message_data = {
        recipient: {
          id: recipient_id
        },
        message: {
          text: message_text
        }
      }
    # begin
    RestClient.post(
        "https://graph.facebook.com/v2.6/me/messages?access_token=#{page_token}",
        message_data.to_json,
        content_type: :json
      )
    # rescue RestClient::ExceptionWithResponse => err
    #   puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    # end
  end

  def self.get_profile(recipient_id)
  end

  def self.send_image(recipient_id, message, page_token)
    message_data = {
      recipient:{
        id: recipient_id
      },
      message:{
        attachment:{
          type: :image,
          payload:{
            url: message
          }
        }
      }
    }
    begin
      RestClient.post(
          "https://graph.facebook.com/v2.6/me/messages?access_token=#{page_token}",
          message_data.to_json,
          content_type: :json
        )
    rescue RestClient::ExceptionWithResponse => err
      puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    end
  end

  def self.quick_replies(recipient_id, message, page_token)
    message_data = {
      recipient:{
        id: recipient_id
      },
      message:{
        text: message,
        quick_replies:[
          {
            content_type: :text,
            title: "Oui",
            payload: "nothing"
          },
          {
            content_type: :text,
            title: "Non",
            payload: "nothing"
          }
        ]
      }
    }
    begin
      RestClient.post(
          "https://graph.facebook.com/v2.6/me/messages?access_token=#{page_token}",
          message_data.to_json,
          content_type: :json
        )
    rescue RestClient::ExceptionWithResponse => err
      puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    end
  end

end
