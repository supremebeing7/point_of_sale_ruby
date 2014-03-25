class Sale < ActiveRecord::Base
  has_many :purchases
end
