class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :desc
      t.string :plan_id
      t.float :price

      t.timestamps
    end
  end
end
