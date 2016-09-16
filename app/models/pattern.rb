class Pattern < ApplicationRecord

  belongs_to :bot
  has_many :histories, dependent: :destroy


  def match(message_text)
    words_user = message_text.scan(/(\w+)\b/)
    words_trigger = self.trigger.scan(/(\w+)\b/)

    words_user.each do |word_user|
      words_trigger.each do |word_trigger|
        if word_user.first == word_trigger.first
          p 'answer form pattern match'
          return self.answer
        end
      end
    end
    nil
  end

end
