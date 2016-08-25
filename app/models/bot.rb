class Bot < ApplicationRecord

  has_secure_token

  belongs_to :user
  has_many :patterns
  has_many :histories

  validates :name, presence: true


  def match_intent_pattern(entities)
    self.patterns.each do |pattern|
      answer_intent = pattern.intent_match(entities)
      return answer_intent if answer_intent
    end
    nil
  end

  def match_text_pattern(message_text)
    self.patterns.each do |pattern|
      answer = pattern.simple_match(message_text)
      return answer if answer
    end
    nil
  end
end
