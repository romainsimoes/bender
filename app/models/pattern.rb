class Pattern < ApplicationRecord

  belongs_to :bot
  has_many :histories


  def match(message_text)
    if message_text == self.trigger
      self.answer
    else
      nil
    end
  end

end
