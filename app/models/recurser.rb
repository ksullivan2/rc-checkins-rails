class Recurser < ActiveRecord::Base
	has_one :group, inverse_of: :recursers

	validates :name, presence: true
	validates :email, presence: true
end
