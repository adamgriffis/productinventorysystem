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
            inventory.update_quantity!(params[:quantity])
          end
        end

        # put /inventories/:id/adjust
        params do 
          requires :adjustment, type: Integer, desc: "The adjustment (negative or positive) for the indicated inventory"
        end
        put 'adjust' do 
          if params.has_key?(:adjustment)
            inventory = Inventory.find params[:id]
            inventory.adjust_quqnaity!(params[:adjustment])
          end
        end
      end
    end
    
  end
end