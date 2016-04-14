class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :room
      t.string :time
      t.references :recursers, index: true, foreign_key: true
      t.string :topic

      t.timestamps null: false
    end
  end
end
