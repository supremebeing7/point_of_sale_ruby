class Cashier < ActiveRecord::Base
  has_many :checkouts
end
