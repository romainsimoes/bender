class Intent < ApplicationRecord

  belongs_to :bot
  has_many :histories, dependent: :destroy

end
