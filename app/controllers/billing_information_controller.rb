class BillingInformationController < ApplicationController

  # GET /orders/new
  # GET /orders/new.json
  def show

  	if Account.is_customer? current_account
  	  @order = Order.where("account_id=?", current_account).last
  	else
	  @order = Order.new
	  @order.build_address
  	end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @order }
    end
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_account.orders.new(params[:order])

    if @order.valid?
      @result = Braintree::Customer.create(
        :first_name => @order.address.first_name,
        :last_name => @order.address.last_name,
        :email => current_account.email,
        :credit_card => {
          :cardholder_name => @order.address.first_name + " " + @order.address.last_name,
          :number => @order.card_number,
          :expiration_date => '05/2015',
          :billing_address => {
            :street_address => @order.address.street_address,
            :extended_address => @order.address.extended_address,
            :locality => @order.address.city,
            :region => @order.address.state,
            :postal_code => @order.address.zip,
            :country_code_alpha2 => @order.address.country
          }
        }
      )

      # No order# has yet been associated to this transaction. The idea is to keep tracking all transaction, either failure or success
      transaction = OrderTransaction.new(:result => @result)
      transaction.save

      if @result.success?

        # mask the credit card number to make sure no one can take advantage of it
        @order.card_number = transaction.mask @order.card_number

        @subscribe = Braintree::Subscription.create(
          :payment_method_token => @result.customer.credit_cards[0].token,
          :plan_id => "v28w"
        )

        current_account.update_attributes(
          :customer_id => @result.customer.id,
          :payment_token => @result.customer.credit_cards[0].token
        )

        respond_to do |format|
          if @order.save

            # Now, order has ben saved, we should associate order with transaction
            transaction.update_attributes(:order => @order)
            
            format.html { redirect_to :billing, :notice => 'Order was successfully created' }
            format.json { render :json => @order, :status => :created, :location => @order }
          else
            format.html { render :action => "show" }
            format.json { render :json => @order.errors, :status => :unprocessable_entity }          
          end
        end
      else
      
        @result.errors.each do |error|
          @order.errors.add(:base, error.message)
        end

        respond_to do |format|
          format.html { render :action => "show" }
          format.json { render :json => @order.errors, :status => :unprocessable_entity }
        end
      end
      
    else
      respond_to do |format|
        format.html { render :action => "show" }
        format.json { render :json => @order.errors, :status => :unprocessable_entity }
      end
    end

  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:order][:id])

    @order.card_number = params[:order][:card_number]
    @order.address_attributes = params[:order][:address_attributes]

    # The idea is to keep tracking all transaction, either failure or success
    transaction = OrderTransaction.new(:result => @customer_changed, :order => @order)

    if @order.valid?
      if @order.card_number_changed?
        @customer_changed = Braintree::Customer.update(
          current_account.customer_id,
          :credit_card => {
            :cardholder_name => @order.address.first_name + " " + @order.address.last_name,
            :number => @order.card_number,
            :expiration_date => "06/2013",
            :options => {
              :update_existing_token => current_account.payment_token,
            },
            :billing_address => {
              :street_address => @order.address.street_address,
              :extended_address => @order.address.extended_address,
              :locality => @order.address.city,
              :region => @order.address.state,
              :postal_code => @order.address.zip,
              :country_code_alpha2 => @order.address.country
            }
          }
        )  
        transaction.save
      elsif @order.address.changed?
        @customer_changed = Braintree::Customer.update(
          current_account.customer_id,
          :first_name => @order.address.first_name,
          :last_name => @order.address.last_name,
          :credit_card => {
            :cardholder_name => @order.address.first_name + " " + @order.address.last_name,
            :options => {
              :update_existing_token => current_account.payment_token,
            },
            :billing_address => {
              :street_address => @order.address.street_address,
              :extended_address => @order.address.extended_address,
              :locality => @order.address.city,
              :region => @order.address.state,
              :postal_code => @order.address.zip,
              :country_code_alpha2 => @order.address.country
            }
          }
        )       
        transaction.save
      end
    end

    respond_to do |format|

      if @order.update_attributes(params[:order]) 
        # mask the credit card number to make sure no one can take advantage of it
        @order.card_number = transaction.mask @order.card_number
            
        @order.update_attributes(:card_number => @order.card_number)

        format.html { redirect_to :billing, :notice => 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "show" }
        format.json { render :json => @order.errors, :status => :unprocessable_entity }
      end
    end
  end


end
