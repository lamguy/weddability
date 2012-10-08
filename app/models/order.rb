class Order < ActiveRecord::Base
  belongs_to :account
  belongs_to :address
  has_many :transactions, :class_name => "OrderTransaction"

  attr_accessible :card_expired_on, :card_number, :card_type, :address_attributes, :transactions_attributes

  accepts_nested_attributes_for :address

  validates :card_number, :presence => true

end
