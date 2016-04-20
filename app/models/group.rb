class Group < ActiveRecord::Base
  has_many :recursers, inverse_of: :group

  @edit_mode = false

  def edit_mode
  	@edit_mode
  end
  
end
