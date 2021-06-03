class CreateByHours < ActiveRecord::Migration[6.1]
  def change
    create_table :by_hours do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :hour_price_cents
      t.integer :recurrence
      t.date :start_pay_day

      t.timestamps
    end
  end
end
