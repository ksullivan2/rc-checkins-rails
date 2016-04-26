class AddTimeToGroups < ActiveRecord::Migration
  def change
    add_reference :groups, :available_time, index: true, foreign_key: true
  end
end
