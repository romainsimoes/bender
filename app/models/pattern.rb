class Pattern < ApplicationRecord

  belongs_to :bot
  has_many :histories

end
