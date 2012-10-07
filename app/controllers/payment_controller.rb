class PaymentController < ApplicationController

	def new
		@tr_data = Braintree::TransparentRedirect.create_customer_data(:redirect_url => :confirm_payment_url)		
	end
end
