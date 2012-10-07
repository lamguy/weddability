class Product < ActiveRecord::Base
  attr_accessible :desc, :name, :plan_id, :price
end
