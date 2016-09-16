class Bot < ApplicationRecord

  has_secure_token

  belongs_to :user
  has_many :patterns, dependent: :destroy
  has_many :intents, dependent: :destroy
  has_many :histories, dependent: :destroy
  has_many :recoveries, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :shop_name, presence: true
  validates :name, presence: true



  def match_pattern(message_text)
    self.patterns.each do |pattern|
      answer = pattern.match(message_text)
      return { answer: answer, pattern_id: pattern.id } if answer
    end
    nil
  end


  def match_intent(entities)
    p 'match_intent'
    entities.each do |intent, array|
      bot_intent = self.intents.where(name: intent)
      unless bot_intent.empty? || (array[0]['confidence'] < 0.7)
        return { answer: bot_intent.first.answer, intent_id: bot_intent.first.id }
      end
    end
    nil
  end

end
