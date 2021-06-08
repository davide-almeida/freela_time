class AddInvoiceDueDateToInParcels < ActiveRecord::Migration[6.1]
  def change
    add_column :in_parcels, :invoice_due_date, :date
  end
end
