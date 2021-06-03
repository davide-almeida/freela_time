class AddCompanyToTask < ActiveRecord::Migration[6.1]
  def change
    add_reference :tasks, :company, null: false, foreign_key: true
  end
end
