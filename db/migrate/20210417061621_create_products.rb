class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.references :user, index: true
      t.references :brand, index: true
      t.references :style, index: true
      t.references :type, index: true
      t.integer :shipping_price_cents
      t.text :note
      t.string :url

      t.timestamps
    end
  end
end
