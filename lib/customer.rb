class Customer < ActiveRecord::Base
	has_many :checkouts
end
