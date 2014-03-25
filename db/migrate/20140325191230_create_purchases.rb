class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.column :customer_id, :int
      t.column :product_id, :int
      t.column :qty, :int

      t.timestamps
    end
  end
end
