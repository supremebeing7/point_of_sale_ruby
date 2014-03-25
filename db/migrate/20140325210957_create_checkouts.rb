class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.column :cashier_id, :int
      t.column :customer_id, :int
      t.column :receipt, :float

      t.timestamps
    end
  end
end
