class AddSaleIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :sale_id, :int
  end
end
