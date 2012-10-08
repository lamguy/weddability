class OrderTransaction < ActiveRecord::Base
  belongs_to :order
  attr_accessible :result, :order

  serialize :result

  def response=(response)
  	self.success = response.success?
  	self.message = response.message
  end

end
