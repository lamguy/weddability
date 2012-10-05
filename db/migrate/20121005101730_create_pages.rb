class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.text :content
      t.references :account

      t.timestamps
    end
    add_index :pages, :account_id
  end
end
