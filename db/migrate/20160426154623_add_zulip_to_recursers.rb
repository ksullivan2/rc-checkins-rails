class AddZulipToRecursers < ActiveRecord::Migration
  def change
    add_column :recursers, :zulip_email, :string
  end
end
