class History < ApplicationRecord

  belongs_to :bot
  belongs_to :pattern
  belongs_to :intent

end
