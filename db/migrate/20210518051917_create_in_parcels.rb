class CreateInParcels < ActiveRecord::Migration[6.1]
  def change
    create_table :in_parcels do |t|
      t.references :in_payment, null: false, foreign_key: true
      t.integer :value_cents
      t.integer :status
      t.integer :parcel_number
      t.date :due_date

      t.timestamps
    end
  end
end
