class Recurser < ActiveRecord::Base
	belongs_to :group

	validates :name, presence: true
	validates :email, presence: true
end
