module ProductInventoryApi
  
  class InventoriesApi < Grape::API
    
    helpers ProductInventoryApi::Helpers::RoutesHelper
    helpers ProductInventoryApi::Helpers::InventoriesHelper
    
    
    resource :inventories do
      desc "Get paginated list of inventories"
      params do 
        use :pagination
      end
      get do
        list_endpoint(Inventory, inventory_json_options, base_record_set: Inventory)
      end

      params do 
        use :inventory_create_params
      end
      post do 
        create_endpoint(Inventory, params)
      end


      params do 
        requires :id, type: Integer, desc: "The inventory ID"
      end
      route_param :id do 
        # get /inventories/:id
        get do 
          inventory = Inventory.find params[:id]

          inventory.as_json(full_inventory_json_options)
        end

        # put /inventories/:id
        params do 
          use :inventory_update_params
        end
        put do 
          update_endpoint(Inventory, params.except(:quantity))

          # I think we should separate quantity updates from the other inventory updates because the inventory updates are going to be much higher volume and are where locking is important
          # so I've created a spearate path specifically for quantity that will be shared with the adjust case (keeping in mind that this is not the high-scale use case in part 2)
          if params.has_key?(:quantity)
            inventory = Inventory.find params[:id]
            inventory.update_quantity(params[:quantity])
          end
        end
      end

      # # POST /products
      # desc 'Create a product with the given information.'
      # params do
      #   use :product_create_update_params
      # end
      # post do
      #   create_endpoint(Product, params)
      # end

      # # search products
      # desc 'Search the products by search keys'
      # params do 
      #   use :search_terms
      #   use :pagination
      # end
      # get 'search' do 
      #   list_endpoint(Product, product_json_options, base_record_set: Product.search_style(params[:style]).search_brand(params[:brand]).search_type(params[:type]))
      # end

      # params do
      #   requires :id, type: Integer, desc: 'The product ID.'
      # end
      # route_param :id do
      #   # GET /products/id
      #   desc "Returns detail about a particular product"
      #   get do
      #     product = Product.find params[:id]

      #     product.as_json(product_json_options)
      #   end

      #   # put /products/id
      #   desc 'updates a product with the given information.'
      #   params do
      #     use :product_create_update_params
      #   end
      #   put do
      #     update_endpoint(Product, params)
      #   end
      # end
    end
    
  end
end