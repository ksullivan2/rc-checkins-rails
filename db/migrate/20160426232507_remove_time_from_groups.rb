class RemoveTimeFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :time, :string
  end
end
