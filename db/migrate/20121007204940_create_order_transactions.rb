class CreateOrderTransactions < ActiveRecord::Migration
  def change
    create_table :order_transactions do |t|
      t.references :order
      t.text :result

      t.timestamps
    end
    add_index :order_transactions, :order_id
  end
end
