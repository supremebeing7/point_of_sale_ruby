require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'cashier'
require 'product'
require 'purchase'
require 'sale'


ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Product.all.each { |product| product.destroy }
    Cashier.all.each { |cashier| cashier.destroy }
    Purchase.all.each { |purchase| purchase.destroy }
    Sale.all.each { |sale| sale.destroy }
 end
end
