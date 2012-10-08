class Address < ActiveRecord::Base
  belongs_to :account
  has_many :orders
  attr_accessible :city, :company, :country, :default, :extended_address, :first_name, :last_name, :street_address, :zip, :state

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :street_address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :country, :presence => true
  
  validates_format_of :zip, :with => /^\d{5}(-\d{4})?$/, :message => "should be in the form 12345 or 12345-1234"


end
