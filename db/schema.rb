# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121007204940) do

  create_table "accounts", :force => true do |t|
    t.string   "customer_id"
    t.string   "email",                  :default => "",    :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
  end

  add_index "accounts", ["email"], :name => "index_wedd_accounts_on_email", :unique => true
  add_index "accounts", ["reset_password_token"], :name => "index_wedd_accounts_on_reset_password_token", :unique => true

  create_table "addresses", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "street_address"
    t.string   "extended_address"
    t.string   "city"
    t.string   "zip"
    t.string   "country"
    t.boolean  "default"
    t.integer  "account_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "state"
  end

  add_index "addresses", ["account_id"], :name => "index_wedd_addresses_on_account_id"

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.text     "result"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "order_transactions", ["order_id"], :name => "index_wedd_order_transactions_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "account_id"
    t.string   "card_type"
    t.string   "card_number"
    t.date     "card_expired_on"
    t.integer  "address_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "orders", ["account_id"], :name => "index_wedd_orders_on_account_id"
  add_index "orders", ["address_id"], :name => "index_wedd_orders_on_address_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "title"
    t.text     "content"
    t.integer  "account_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pages", ["account_id"], :name => "index_wedd_pages_on_account_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "plan_id"
    t.float    "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "redactor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], :name => "idx_redactor_assetable"
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_redactor_assetable_type"

end
