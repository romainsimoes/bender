class History < ApplicationRecord

  belongs_to :bot
  belongs_to :pattern, dependent: :destroy

end
