class Order < ActiveRecord::Base
  belongs_to :account
  belongs_to :address
  attr_accessible :card_expired_on, :card_number, :card_type, :address_attributes

  accepts_nested_attributes_for :address
end