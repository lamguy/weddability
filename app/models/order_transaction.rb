class OrderTransaction < ActiveRecord::Base
  belongs_to :order
  attr_accessible :result
end
