class CreateWorkGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :work_groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
