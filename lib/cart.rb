class Cart < ActiveRecord::Base
  belongs_to :checkout
  belongs_to :purchase
end
