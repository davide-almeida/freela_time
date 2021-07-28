class AddThemeToSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :theme, :integer
  end
end
