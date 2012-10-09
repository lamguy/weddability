class OrderTransaction < ActiveRecord::Base
  belongs_to :order
  attr_accessible :result, :order

  serialize :result

	def response=(response)
		self.success = response.success?
		self.message = response.message
	end


	def last_digits(number)    
	 	number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1) 
	end

	def mask(number)
		"XXXX-XXXX-XXXX-#{last_digits(number)}"
	end

end
