class CreateAvailableTimes < ActiveRecord::Migration
  def change
    create_table :available_times do |t|
      t.string :alias
      t.string :time

      t.timestamps null: false
    end
  end
end
