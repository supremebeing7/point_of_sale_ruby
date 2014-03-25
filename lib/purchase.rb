class Purchase < ActiveRecord::Base
  belongs_to :product
  has_many :carts
end
