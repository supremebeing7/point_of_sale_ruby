require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'cart'
require 'cashier'
require 'checkout'
require 'customer'
require 'product'
require 'purchase'


ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Cart.all.each { |cart| cart.destroy }
    Cashier.all.each { |cashier| cashier.destroy }
    Checkout.all.each { |checkout| checkout.destroy }
    Customer.all.each { |customer| customer.destroy }
    Product.all.each { |product| product.destroy }
    Purchase.all.each { |purchase| purchase.destroy }
 end
end
