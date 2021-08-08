class AddOwnerUserIdToWorkGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :work_groups, :owner_user_id, :integer
  end
end
