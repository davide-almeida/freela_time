class CreateUserWorkGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :user_work_groups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :work_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
