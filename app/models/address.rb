class Address < ActiveRecord::Base
  belongs_to :account
  has_many :orders
  attr_accessible :city, :company, :country, :default, :extended_address, :first_name, :last_name, :street_address, :zip


end
