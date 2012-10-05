class AddAdminToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :admin, :boolean, :default => false
  end

  def down
  	remove_column :accounts, :admin
  end
end
