class Checkout < ActiveRecord::Base
  has_many :carts
  has_many :purchases, through: :carts
  belongs_to :cashier
end
