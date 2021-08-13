class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.string :link
      t.date :due_date
      t.integer :status
      t.integer :invite_type

      t.timestamps
    end
  end
end
