class Bot < ApplicationRecord

  has_secure_token

  belongs_to :user
  has_many :patterns
  has_many :histories

  validates :name, presence: true


  def match_intent_pattern(entities)
    self.patterns.each do |pattern|
      answer = pattern.match(message_text)
      return { answer: answer, pattern: pattern.id }  if answer
    end
    { answer: nil, pattern: nil }
  end

  def match_text_pattern(message_text)
    self.patterns.each do |pattern|
      answer = pattern.simple_match(message_text)
      return answer if answer
    end
    nil
  end
end
