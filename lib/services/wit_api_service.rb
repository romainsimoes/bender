class WitApiService

  def self.get_entities(text)
    data = RestClient.post(
        "https://api.wit.ai/message?v=20160825&q=#{text}",
        {},
        { 'Authorization' => "Bearer #{ENV['WIT_KEY']}",
          content_type: 'application/json',
         }
      )

    json = JSON.parse(data)
    entities = json['entities']
    p entities


    if entities.empty?
      return nil
    else
      return entities
    end
  end

  def self.get_date(text)
    data = RestClient.post(
        "https://api.wit.ai/message?v=20160825&q=#{text}",
        {},
        { 'Authorization' => "Bearer #{ENV['WIT_KEY']}",
          content_type: 'application/json',
         }
      )

    json = JSON.parse(data)
    entities = json['entities']
    p entities


    if entities.empty?
      return nil
    else
      return entities
    end
  end

end
