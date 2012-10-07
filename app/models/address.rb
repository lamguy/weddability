class Address < ActiveRecord::Base
  belongs_to :account
  attr_accessible :city, :company, :country, :default, :extended_address, :first_name, :last_name, :street_address, :zip
end
