require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'cashier'
require 'product'
require 'purchase'
require 'cart'
require 'checkout'


ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Product.all.each { |product| product.destroy }
    Cashier.all.each { |cashier| cashier.destroy }
    Purchase.all.each { |purchase| purchase.destroy }
    Cart.all.each { |cart| cart.destroy }
    Checkout.all.each { |checkout| checkout.destroy }
 end
end
