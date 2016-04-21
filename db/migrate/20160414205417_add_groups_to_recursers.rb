class AddGroupsToRecursers < ActiveRecord::Migration
  def change
    add_reference :recursers, :group, index: true, foreign_key: true
  end
end
