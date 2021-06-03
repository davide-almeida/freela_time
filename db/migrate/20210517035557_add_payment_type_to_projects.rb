class AddPaymentTypeToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :payment_type, :integer
  end
end
