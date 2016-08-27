class Recovery < ApplicationRecord

  belongs_to :bot

  def outdated?
    self.updated_at < (DateTime.now - (20/1440.0))
  end
end
