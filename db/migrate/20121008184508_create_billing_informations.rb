class CreateBillingInformations < ActiveRecord::Migration
  def change
    create_table :billing_informations do |t|

      t.timestamps
    end
  end
end
