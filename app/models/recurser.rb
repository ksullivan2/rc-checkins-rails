class Recurser < ActiveRecord::Base
  has_one :group, inverse_of: :recursers

  validates :name, presence: true
  validates :email, presence: true
  validates :zulip_email, :format => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
end
