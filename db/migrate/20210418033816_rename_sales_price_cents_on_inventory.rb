class RenameSalesPriceCentsOnInventory < ActiveRecord::Migration[6.1]
  def change
    rename_column :inventories, :sales_price_cents, :sale_price_cents
  end
end
