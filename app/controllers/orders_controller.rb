class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = current_account.orders

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new
    @order.build_address

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_account.orders.new(params[:order])

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

    transaction = OrderTransaction.new(:result => @result)
    transaction.save

    if @result.success?
      current_account.update_attributes(:customer_id => @result.customer.id)

      @subscribe = Braintree::Subscription.create(
        :payment_method_token => @result.customer.credit_cards[0].token,
        :plan_id => "v28w"
      )

      respond_to do |format|
        if @order.save

          transaction.update_attributes(:order => @order)
          format.html { redirect_to @order, :notice => 'Order was successfully created' }
          format.json { render :json => @order, :status => :created, :location => @order }
        else
          format.html { render :action => "new" }
          format.json { render :json => @order.errors, :status => :unprocessable_entity }          
        end
      end
    else
    
      @result.errors.each do |error|
        @order.errors.add(:base, error.message)
      end

      respond_to do |format|
        format.html { render :action => "new" }
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

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
end
