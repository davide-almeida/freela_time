class AddStartInvoiceDayToByHours < ActiveRecord::Migration[6.1]
  def change
    add_column :by_hours, :start_invoice_day, :date
  end
end
