module ProductInventoryApi
  
  class ProductsApi < Grape::API
    
    helpers ProductInventoryApi::Helpers::RoutesHelper
    helpers ProductInventoryApi::Helpers::ProductsHelper
    
    
    resource :products do
      desc "Get paginated list of products"
      params do 
        use :pagination
      end
      get do
        list_endpoint(Product, product_json_options, base_record_set: Product.preload(:product_brand, :product_style, :product_type))
      end


      # POST /products
      desc 'Create a product with the given information.'
      params do
        use :product_create_update_params
      end
      post do
        create_endpoint(Product, params)
      end


      params do
        requires :id, type: Integer, desc: 'The product ID.'
      end
      route_param :id do
        # GET /products/id
        desc "Returns detail about a particular product"
        get do
          product = Product.find params[:id]

          product.as_json(product_json_options)
        end

        # put /products/id
        desc 'updates a product with the given information.'
        params do
          use :product_create_update_params
        end
        put do
          update_endpoint(Product, params)
        end
      end
    end
    
  end
end