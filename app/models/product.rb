class Product < ApplicationRecord
  belongs_to :bot
  mount_uploader :photo, PhotoUploader
end
