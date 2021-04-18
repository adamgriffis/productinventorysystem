module ProductInventoryApi
  module Helpers
    module InventoriesHelper
      extend Grape::API::Helpers
      
      # Params for by inventory create.
      params :inventory_create_params do
        requires :product_id, type: Integer, desc: "The product ID associated with this inventory record."
        requires :quantity, type: Integer, desc: "How many of this SKU are in inventory"
        requires :color, type: String, desc: "Item color"
        requires :size, type: String, desc: "Item size"
        requires :sku, type: String, desc: "Item SKU"
        requires :weight, type: Integer, desc: "Item weight. Must be greater than zero"
        requires :length, type: Integer, desc: "Item length"
        requires :height, type: Integer, desc: "Item height"
        requires :width, type: Integer, desc: "Item width"
        requires :note, type: String, desc: "Item note"
        requires :price_cents, type: Integer, desc: "Price of the sku"
        requires :sale_price_cents, type: Integer, desc: "Price of the sku on sale"
        requires :cost_cents, type: Integer, desc: "cost of the sku"
      end
      
      # Params shared by product create/update.
      params :inventory_update_params do
        optional :product_id, type: Integer, desc: "The product ID associated with this inventory record."
        optional :quantity, type: Integer, desc: "How many of this SKU are in inventory"
        optional :color, type: String, desc: "Item color"
        optional :size, type: String, desc: "Item size"
        optional :sku, type: String, desc: "Item SKU"
        optional :weight, type: Integer, desc: "Item weight. Must be greater than zero"
        optional :length, type: Integer, desc: "Item length"
        optional :height, type: Integer, desc: "Item height"
        optional :width, type: Integer, desc: "Item width"
        optional :note, type: String, desc: "Item note"
        optional :price_cents, type: Integer, desc: "Price of the sku"
        optional :sale_price_cents, type: Integer, desc: "Price of the sku on sale"
        optional :cost_cents, type: Integer, desc: "cost of the sku"
      end

      def inventory_json_options
        {only: [:id, :product_id, :quantity, :color, :size, :price_cents, :sale_price_cents, :sku]}
      end

      def full_inventory_json_options
        {only: [:id, :product_id, :quantity, :color, :size, :price_cents, :sale_price_cents, :weight, :notes, :sku, :height, :width, :length, :cost_cents]}
      end
      
    end
  end
end
