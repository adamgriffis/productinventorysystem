module ProductInventoryApi
  module Helpers
    module ProductsHelper
      extend Grape::API::Helpers
      
      # Params for product create.
      params :product_create_params do
        requires :name, type: String, desc: "The product's name."
        optional :description, type: String, desc: "Description of the product"
        requires :type, type: String, desc: "The product's type (clothing, etc)."
        requires :style, type: String, desc: "The product's style."
        requires :brand, type: String, desc: "The product's brand."
        requires :shipping_price_cents, type: Integer, desc: "The proeuct's shipping price"
      end

      params :product_update_params do
        optional :name, type: String, desc: "The product's name."
        optional :description, type: String, desc: "Description of the product"
        optional :type, type: String, desc: "The product's type (clothing, etc)."
        optional :style, type: String, desc: "The product's style."
        optional :brand, type: String, desc: "The product's brand."
        optional :shipping_price_cents, type: Integer, desc: "The proeuct's shipping price"
      end

      params :search_terms do 
        optional :style, type: String, desc: "The style to use when searching products"
        optional :brand, type: String, desc: "The brand to use when searching products"
        optional :type, type: String, desc: "The type to use when searching products"
      end

      def product_json_options
        {only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}
      end
      
    end
  end
end
