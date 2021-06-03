class CreateProjectStorages < ActiveRecord::Migration[6.1]
  def change
    create_table :project_storages do |t|
      t.string :name
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
