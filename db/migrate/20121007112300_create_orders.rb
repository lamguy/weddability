class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :account
      t.string :card_type
      t.string :card_number
      t.date :card_expired_on
      t.references :address

      t.timestamps
    end
    add_index :orders, :account_id
    add_index :orders, :address_id
  end
end
