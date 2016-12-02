class FacebookRequestService

  def self.subscribe(page_token)
    app_location = "https://graph.facebook.com/v2.6/me/subscribed_apps?access_token=#{page_token}"
    data = RestClient.post(app_location, nil)
    json = JSON.parse(data)
    json['success'] # return true if success, false otherwise
  end

  def self.send_message(recipient_id, message_text, bot)
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
        "https://graph.facebook.com/v2.6/me/messages?access_token=#{bot.page_access_token}",
        message_data.to_json,
        content_type: :json
      )
    # rescue RestClient::ExceptionWithResponse => err
    #   puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    # end
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

  def self.quick_replies(recipient_id, message, bot)
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
          "https://graph.facebook.com/v2.6/me/messages?access_token=#{bot.page_access_token}",
          message_data.to_json,
          content_type: :json
        )
    rescue RestClient::ExceptionWithResponse => err
      puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    end
  end

  def self.map_template(recipient_id, bot)
    message_data = {
      recipient:{
        id: recipient_id
      },
      message:{
        attachment:{
          type: :template,
          payload:{
            template_type: :generic,
            elements:[
              {
                title: bot.name,
                image_url: "https://maps.googleapis.com/maps/api/staticmap?markers=color:red|#{bot.street}#{bot.city}&size=300x150&zoom=18&maptype=roadmap",
                subtitle: bot.street + ", " + bot.city,
                buttons:[
                  {
                    type: :web_url,
                    url: "https://www.google.fr/maps/search/#{bot.street}, #{bot.city}",
                    title: "Allez-y!"
                  }
                ]
              }
            ]
          }
        }
      }
    }
    begin
    RestClient.post(
        "https://graph.facebook.com/v2.6/me/messages?access_token=#{bot.page_access_token}",
        message_data.to_json,
        content_type: :json
        )
    rescue RestClient::ExceptionWithResponse => err
      puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    end
  end

  def self.item_template(recipient_id, bot)
    message_data = {
      recipient:{
        id: recipient_id
      },
      message:{
        attachment:{
          type: :template,
          payload:{
            template_type: :generic,
            elements:[]
          }
        }
      }
    }
    bot.products.each do |product|
      message_data[:message][:attachment][:payload][:elements] << {
        title: product.name,
        image_url: product.photo_url,
        subtitle: product.description + " " + product.price.to_s + "€",
        buttons:[
          {
            type: "postback",
            title: product.name,
            payload: product.name
          }
        ]
      }
    end

    begin
    RestClient.post(
        "https://graph.facebook.com/v2.6/me/messages?access_token=#{bot.page_access_token}",
        message_data.to_json,
        content_type: :json
        )
    rescue RestClient::ExceptionWithResponse => err
      puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    end
  end

  def self.send_receipt_template(recipient_id, bot, p2, address)
    products = []
    bot.products.each do |pdt|
      p2.each do |p|
        if pdt.name == p
          products << pdt
        end
      end
    end

    sum = 0
    products.each { |x|sum += x.price.to_i }

    num_of_product = p2.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
    json = user_info(recipient_id, bot)
    first_name = json["first_name"]
    last_name = json["last_name"]
    message_data = {
      recipient:{
        id: recipient_id
      },
      message:{
        attachment:{
          type: :template,
          payload:{
            template_type: :receipt,
            recipient_name: first_name + " " + last_name,
            order_number: "200",
            currency: "EUR",
            payment_method: "espèce",
            elements:[],
            summary:{
              total_cost: sum
            }
          }
        }
      }
    }

    products.each do |pr|
      message_data[:message][:attachment][:payload][:elements] <<
        {
          title: pr.name,
          subtitle: pr.description,
          quantity: num_of_product[pr.name],
          price: pr.price,
          currency: "EUR",
          image_url: pr.photo_url
        }
    end

    begin
    RestClient.post(
        "https://graph.facebook.com/v2.6/me/messages?access_token=#{bot.page_access_token}",
        message_data.to_json,
        content_type: :json
        )
    rescue RestClient::ExceptionWithResponse => err
      puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    end
  end

  def self.user_info(recipient_id, bot)
    url = "https://graph.facebook.com/v2.6/#{recipient_id}?fields=first_name,last_name,profile_pic,locale,timezone,gender&access_token=#{bot.page_access_token}"
    response = RestClient.get(url)
    json = JSON.parse(response)
    return json
  end

  def self.processing_message(recipient_id, bot)
    message_data = {
      recipient: {
        id: recipient_id
      },
      sender_action: :typing_on
    }
    begin
    RestClient.post(
        "https://graph.facebook.com/v2.6/me/messages?access_token=#{bot.page_access_token}",
        message_data.to_json,
        content_type: :json
        )
    rescue RestClient::ExceptionWithResponse => err
      puts "\nFacebook API response from invalid request:\n#{err.response}\n\n"
    end
  end
end
