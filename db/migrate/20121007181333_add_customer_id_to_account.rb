class AddCustomerIdToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :customer_id, :string, :after => :account_id
  end
end
