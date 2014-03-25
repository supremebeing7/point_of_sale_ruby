class RemovePurchaseIdFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :purchase_id, :int
  end
end
