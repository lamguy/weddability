class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :customer_id, :payment_token, :first_name, :last_name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :pages
  has_many :addresses
  has_many :orders

  def full_name
  	[first_name, last_name].join(" ")
  end

  def self.is_customer? account
    account.customer_id? && account.payment_token?
  end

end
