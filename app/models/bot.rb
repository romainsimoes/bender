class Bot < ApplicationRecord

  has_secure_token

  belongs_to :user

  validates :name, presence: true

end
