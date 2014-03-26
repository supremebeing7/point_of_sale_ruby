class AddPasswordToCashiers < ActiveRecord::Migration
  def change
  	add_column :cashiers, :password, :string
  end
end
