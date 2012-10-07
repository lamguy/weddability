class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :street_address
      t.string :extended_address
      t.string :city
      t.string :zip
      t.string :country
      t.boolean :default
      t.references :account

      t.timestamps
    end
    add_index :addresses, :account_id
  end
end
