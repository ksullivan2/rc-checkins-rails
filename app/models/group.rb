class Group < ActiveRecord::Base
  has_many :recursers, inverse_of: :group

end
