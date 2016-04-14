class CreateGroupLists < ActiveRecord::Migration
  def change
    create_table :group_lists do |t|
      t.references :groups, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
