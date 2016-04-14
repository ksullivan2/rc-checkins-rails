class Group < ActiveRecord::Base
  has_many :recursers
  belongs_to :group_list
end
