class Pattern < ApplicationRecord

  belongs_to :bot
  has_many :histories, dependent: :destroy


  def simple_match(message_text)
    words_user = message_text.scan(/(\w+)\b/)
    words_trigger = self.trigger.scan(/(\w+)\b/)

    words_user.each do |word_user|
      words_trigger.each do |word_trigger|
        if word_user.first == word_trigger.first
          p 'answer form simple_match'
          return self.answer
        end
      end
    end
    nil
  end

  def intent_match(entities)
    entities.each do |intent, array|
      if (self.trigger == intent) && (array[0]['confidence'] > 0.85 )
        p 'answer form intent_match'
        return self.answer
      end
    end
    nil
  end

end
