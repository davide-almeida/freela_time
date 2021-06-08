class CreateGoalInPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :goal_in_payments do |t|
      t.integer :goal_value_cents
      t.datetime :start_date
      t.datetime :end_date
      # t.integer :status
      t.references :goal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
