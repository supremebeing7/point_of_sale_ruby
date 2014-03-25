require 'active_record'
require './lib/product'
require './lib/cashier'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Welcome to the Register"
  menu
end

def menu
  choice = nil
  until choice == 'x'
    puts "Press 'a' to enter the product's Name & price"
    puts "Press 's' to search products by name"
    puts "Press 'l' to list all products"
    puts "Press 'u' to update a product"
    puts "Press 'd' to delete a product"
    puts "Press 'c' to create a new cashier ID"
    puts "Press 'cl' to list all cashiers"
    puts "Press 'uc' to update a cashier"
    puts "Press 'dc' to delete a cashier"
    puts "Press 'x' to exit"
    choice = gets.chomp.downcase
    case choice
      when 'a'
        add_product
      when 's'
        search_by_product_name
      when 'l'
        list_all_products
      when 'u'
        update_product
      when 'd'
        delete_product
      when 'c'
        new_cashier
      when 'cl'
        list_cashiers
      when 'uc'
        update_cashier
      when 'dc'
        delete_cashier
      when 'x'
        "Good Bye!"
      else
        "This is an invalid option"
    end
  end
end

def add_product
  puts "What is the name of the product?"
  product_name = gets.chomp
  puts "How much does it cost?"
  product_price = gets.chomp
  if !Product.exists? ({:name => product_name, :price => product_price})
    product = Product.new({:name => product_name, :price => product_price})
    product.save
  else
    product = Product.where({:name => product_name, :price => product_price}).first
  end
  puts "#{product.name}: $#{"%.2f" % product.price} ADDED!"
end

def search_by_product_name
  puts "Enter product name"
  input_name = gets.chomp
  product = Product.where(name: input_name)
  product.each { |product| puts "(ID:#{product.id}) #{product.name}: $#{"%.2f" % product.price}"}
  product.first
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
  product.update(name: updated_name, price: updated_price)
  puts "#{product.name}: #{product.price} UPDATED"
end


def delete_product
  product = search_by_product_name
  product.destroy
end

def new_cashier
  puts"Enter the name of the new cashier:"
  cashier_name = gets.chomp
  cashier = Cashier.new(name: cashier_name)
  cashier.save
  puts "New cashier: (ID:#{cashier.id}) #{cashier.name} has been added "
end

def list_cashiers
  puts "Here is an inventory list of your cashiers"
  cashiers = Cashier.all
  cashiers.each { |cashier| puts "(ID:#{cashier.id}) #{cashier.name}" }
end

def update_cashier
  list_cashiers
  puts "Type the ID of the cashier you want to edit"
  cashier_id = gets.chomp.to_i
  puts "Enter your new name"
  updated_name = gets.chomp
  cashier = Cashier.find(cashier_id)
  cashier.update(name: updated_name)
  puts "#{cashier.name} UPDATED"
end

def delete_cashier
  puts "Enter the ID of the Cashier to delete"
  id = gets.chomp
  del_cashier = Cashier.find(id)
  del_cashier.destroy
end


welcome
