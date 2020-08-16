class ChangeIsAdminColumnOnUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :is_admin, :boolean
    change_column_default :users, :is_admin, false
  end
end
