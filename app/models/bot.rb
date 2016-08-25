class Bot < ApplicationRecord

  has_secure_token

  belongs_to :user
  has_many :patterns, dependent: :destroy
  has_many :histories

  validates :name, presence: true

  def match_pattern(message_text)
    self.patterns.each do |pattern|
      answer = pattern.match(message_text)
      return { answer: answer, pattern: pattern.id }  if answer
    end
    { answer: nil, pattern: nil }
  end

end
