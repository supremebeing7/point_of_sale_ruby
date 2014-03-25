class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.column :cashier_id, :integer
      t.column :purchase_id, :integer

      t.timestamps
    end
  end
end
