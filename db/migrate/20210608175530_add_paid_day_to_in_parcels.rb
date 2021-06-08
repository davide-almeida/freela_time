class AddPaidDayToInParcels < ActiveRecord::Migration[6.1]
  def change
    add_column :in_parcels, :paid_day, :date
  end
end
