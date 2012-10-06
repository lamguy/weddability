class AddFirstNameAndLastNameToAccount < ActiveRecord::Migration
  def up
    add_column :accounts, :first_name, :string, :after => :email
    add_column :accounts, :last_name, :string, :after => :first_name
  end

  def down
  	remove_column :accounts, :first_name
  	remove_column :accounts, :last_name
  end
end
