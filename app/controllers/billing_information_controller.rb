class BillingInformationController < ApplicationController

  # GET /orders/new
  # GET /orders/new.json
  def show
    @order = Order.new
    @order.build_address

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
            
            format.html { redirect_to :billing_url, :notice => 'Order was successfully created' }
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
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, :notice => 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @order.errors, :status => :unprocessable_entity }
      end
    end
  end


end
