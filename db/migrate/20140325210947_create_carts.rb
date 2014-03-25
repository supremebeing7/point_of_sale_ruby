class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.column :checkout_id, :int
      t.column :purchase_id, :int

      t.timestamps
    end
  end
end
