class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.integer :quantity
      t.string :color
      t.string :size
      t.integer :weight
      t.integer :price_cents
      t.integer :sales_price_cents
      t.integer :cost_cents
      t.string :sku
      t.integer :length
      t.integer :width
      t.integer :height
      t.text :note

      t.references :user, index: true
      t.references :product, index: true

      t.timestamps
    end
  end
end
