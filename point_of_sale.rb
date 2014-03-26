require 'active_record'
require './lib/cart'
require './lib/cashier'
require './lib/checkout'
require './lib/customer'
require './lib/product'
require './lib/purchase'
require 'pry'
require 'pry-rails'
require 'pry-remote'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  system "clear"
  puts "Welcome to the Register"
  puts "Press 'Enter' to begin!"
  gets.chomp
  main_menu
end

def main_menu
  choice = nil
  until choice == 'X'
    system "clear"
    puts "
Please select from the following options:
1. Add Product
2. Search Products
3. Update Product
4. Delete Product
5. Add Cashier
6. Search Cashiers
7. Update Cashier
8. Delete Cashier
9. Checkout
10. Return Item
11. Tally Today's Sales
12. Tally Sales by Period
13. View Cashier Performance

Type a number to make a selection, or 'X' to exit."

    choice = gets.chomp.upcase
    case choice
    when '1'
      add_product
    when '2'
      search_by_product_name
    when '3'
      update_product
    when '4'
      delete_product
    when '5'
      new_cashier
    when '6'
      search_by_cashier_name
    when '7'
      update_cashier
    when '8'
      delete_cashier
    when '9'
      checkout
    when '10'
      return_items
    when '11'
      sales_day
    when '12'
      sales_period
    when '13'
      customers_served

    when 'X'
      puts "Good Bye!"
    else
      puts "Invalid selection"
      sleep(1.5)
    end
  end
end

def add_product
  puts "What is the name of the product?"
  product_name = gets.chomp
  puts "How much does it cost?"
  product_price = gets.chomp
  if !Product.exists? ({name: product_name})
    product = Product.create({:name => product_name, :price => product_price})
  else
    product = Product.where({:name => product_name}).first
    product.update(price: product_price)
  end
  puts "#{product.name}: $#{"%.2f" % product.price} ADDED!"
  sleep(2)
end

def search_by_product_name
  puts "Enter product name"
  Product.find_by name: gets.chomp
end

def list_all_products
  puts "Here is an inventory list of your products"
  products = Product.all
  products.each { |product| puts "(ID:#{product.id}) #{product.name}: $#{"%.2f" % product.price}" }
end

def update_product
  product = search_by_product_name
  puts "Enter your new name"
  updated_name = gets.chomp
  puts "Enter your new price"
  updated_price = gets.chomp
  puts "#{product.name}: #{product.price} UPDATED TO #{updated_name}: #{updated_price}"
  product.update(name: updated_name, price: updated_price)
  sleep(2)
end


def delete_product
  product = search_by_product_name
  puts "#{product.name} DELETED"
  product.destroy
  sleep(2)
end

def new_cashier
  puts"Enter the name of the new cashier:"
  cashier_name = gets.chomp
  if !Cashier.exists? ({name: cashier_name})
    cashier = Cashier.create({name: cashier_name})
  else
    cashier = Cashier.where({name: cashier_name}).first
  end
  puts "New cashier: (ID:#{cashier.id}) #{cashier.name} has been added"
  sleep(2)
end

def search_by_cashier_name
  puts "Enter cashier name"
  Cashier.find_by name: gets.chomp
end

def list_cashiers
  puts "Here is an inventory list of your cashiers"
  cashiers = Cashier.all
  cashiers.each { |cashier| puts "(ID:#{cashier.id}) #{cashier.name}" }
end

def update_cashier
  cashier = search_by_cashier_name
  puts "Enter new cashier name"
  updated_name = gets.chomp
  puts "#{cashier.name} UPDATED TO #{updated_name}"
  cashier.update(name: updated_name)
  sleep(2)
end

def delete_cashier
  cashier = search_by_cashier_name
  puts "#{cashier.name} DELETED"
  cashier.destroy
  sleep(2)
end

def checkout
  system "clear"
  cashier = search_by_cashier_name
  puts "Enter a customer name"
  customer_name = gets.chomp
  if !Customer.exists? ({name: customer_name})
    customer = Customer.create({name: customer_name})
  else
    customer = Customer.where({name: customer_name}).first
  end
  new_checkout = Checkout.create({cashier_id: cashier.id, customer_id: customer.id, receipt: 0})
  add_to_checkout(new_checkout)
  receipt = 0
  Cart.where(checkout_id: new_checkout.id).each do |cart|
    puts "\t---  #{cart.purchase.product.name}  ---"
    puts "\t$#{'%.2f%' % cart.purchase.product.price} * QTY: #{cart.purchase.qty}"
    puts "\t$#{'%.2f%' % (cart.purchase.qty * cart.purchase.product.price)}\n\n"
    receipt += cart.purchase.qty * cart.purchase.product.price
  end
  new_checkout.update(cashier_id: cashier.id, receipt: receipt)
  puts "---- Your total is $#{'%.2f%' % receipt} ----\n\n"
  puts "Press 'Enter' to return to the main menu"
  gets.chomp
end

def add_to_checkout(new_checkout)
  choice = "Y"
  until choice != 'Y'
    puts "Which item would you like to purchase?"
    list_all_products
    product = search_by_product_name
    puts "Quantity:"
    qty = gets.chomp.to_i
    new_purchase = Purchase.create({product_id: product.id, qty: qty})
    Cart.create({checkout_id: new_checkout.id, purchase_id: new_purchase.id})
    puts "Add more items? ( y / n )"
    choice = gets.chomp.upcase
  end
end

def sales_day
  day_total = Time.now.strftime("%m/%d/%Y")
  dailysale = Checkout.where('updated_at > ?', day_total).sum("receipt")
  puts "Total sales for today, #{day_total}: $#{dailysale}\n\n"
  puts "Press 'Enter' to return to the main menu"
  gets.chomp
end

def sales_period
  puts "Give the start date and end date for the period for which you would like total sales (format: mm/dd/yyyy)"
  puts "Start date:"
  start_date = gets.chomp
  puts "End date:"
  end_date = gets.chomp
  period_sales = Checkout.where(updated_at: start_date..end_date).sum("receipt")
  puts "Total sales for the period #{start_date} - #{end_date}: $#{period_sales}\n\n"
  puts "Press 'Enter' to return to the main menu"
  gets.chomp
end

def customers_served
  puts "For which cashier would you like details?"
  cashier = search_by_cashier_name
  puts "Give the start date and end date for the period for which you would like total sales (format: mm/dd/yyyy)"
  puts "Start date:"
  start_date = gets.chomp
  puts "End date:"
  end_date = gets.chomp
  customer_count = Checkout.where(cashier_id: cashier.id).count
  puts "For the period #{start_date} - #{end_date}, #{cashier.name} served #{customer_count} customers\n\n"
  puts "Press 'Enter' to return to the main menu"
  gets.chomp
end

def return_items
  puts "What is the customer name?"
  customer = Customer.find_by name: gets.chomp
  puts "Which item would you like to return?"
  puts "(Enter 'list' to see a list of this customer's purchases.)"
  item_name = gets.chomp
  case item_name
  when 'list', 'LIST', 'List'
    customer.checkouts.each do |checkout|
      checkout.carts.each { |cart| puts cart.purchase.product.name }
    end
    return_items
  else
    customer.checkouts.each do |checkout|
      checkout.carts.each do |cart|
        if cart.purchase.product.name == item_name
          cart.purchase.update(qty: cart.purchase.qty - 1)
          puts "#{cart.purchase.product.name} has been returned"
          puts "--- $#{'%.2f' % cart.purchase.product.price} has been refunded"
          checkout.update(receipt: checkout.receipt - cart.purchase.product.price)
          puts "\n\nPress 'enter' to return to the main menu."
          gets.chomp
          #ADD TO RETURNS TABLE
        end
      end
    end
  end
end

welcome
