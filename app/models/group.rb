class Group < ActiveRecord::Base
  has_many :recursers, inverse_of: :group
  has_one :available_time

  validates :room, presence: true

  def time
    if self.available_time_id
      test = AvailableTime.find(self.available_time_id)
      test.time
    else
      "no time found"
    end
  end
end
