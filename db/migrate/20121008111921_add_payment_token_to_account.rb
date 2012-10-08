class AddPaymentTokenToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :payment_token, :string, :after => :customer_id
  end
end
