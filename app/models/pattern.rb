class Pattern < ApplicationRecord

  belongs_to :bot
  has_many :histories


  def simple_match(message_text)
    words_user = message_text.scan(/(\w+)\b/)
    words_trigger = self.trigger.scan(/(\w+)\b/)

    words_user.each do |word_user|
      words_trigger.each do |word_trigger|
        if word_user.first == word_trigger.first
          return self.answer
        end
      end
    end
    nil
  end

  def intent_match(entities)
    entities.each do |intent, array|
      if (self.trigger == intent) && (array[0]['confidence'] > 0.85 )
        return self.answer
      end
    end
    nil
  end

end
