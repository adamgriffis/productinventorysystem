module ProductInventoryApi
  
  class ApiV1 < Grape::API
    
    helpers ProductInventoryApi::Helpers::ErrorsHelper
    helpers ProductInventoryApi::Helpers::AuthHelper
    
    version 'v1', using: :header, vendor: "ProductInventory"
    prefix :api
    format :json
    
    # Mount Auth API
    mount ProductInventoryApi::LoginApi
    
    before do
      user = authenticate_jwt

      ActsAsTenant.current_tenant = user

      return {message: "User not authenticated"} unless user
    end

    rescue_from :all do |e|
      # Log it
      Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
    end

    # Mount all v1 resource APIs here.
    mount ProductInventoryApi::ProductsApi
    mount ProductInventoryApi::InventoriesApi
    
    # Enable swagger documentation at /api/v1/swagger_doc. This endpoint spits out JSON that can be read by
    # the npm module Swagger-UI, which allows browsing and testing of the API.
    add_swagger_documentation
  end
  
end
