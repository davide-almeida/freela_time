class AddHostIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :host_id, :integer, null: true
  end
end
