class CreateByProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :by_projects do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :payment_type
      t.integer :total_value_cents
      t.integer :total_parcel
      t.integer :recurrence
      t.date :start_invoice_day
      t.date :start_pay_day

      t.timestamps
    end
  end
end
