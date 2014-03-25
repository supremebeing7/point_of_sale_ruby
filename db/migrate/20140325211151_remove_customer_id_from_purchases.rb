class RemoveCustomerIdFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :customer_id, :int
  end
end
