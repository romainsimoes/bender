class Bot < ApplicationRecord

  has_secure_token

  belongs_to :user
  has_many :patterns, dependent: :destroy
  has_many :histories, dependent: :destroy
  has_many :recoveries, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :shop_name, presence: true
  validates :name, presence: true



  def match_text_pattern(message_text)
    self.patterns.each do |pattern|
      answer = pattern.simple_match(message_text)
      return { answer: answer, pattern_id: pattern.id } if answer
    end
    nil
  end


  def match_intent_pattern(entities)
    self.patterns.each do |pattern|
      answer = pattern.intent_match(entities)
      return { answer: answer, pattern_id: pattern.id } if answer
    end
    nil
  end

end
