module ProductInventoryApi
  module Helpers
  
    # Helper for managing common route parameterization.
    module RoutesHelper
      extend Grape::API::Helpers
      
      DEFAULT_PAGE = 1
      DEFAULT_PAGE_SIZE = 25
      
      # Enable pagination and pagination defaults.
      params :pagination do
        optional :page, type: Integer, default: DEFAULT_PAGE, desc: "Which page of data to pull. Default #{DEFAULT_PAGE}."
        optional :limit, type: Integer, default: DEFAULT_PAGE_SIZE, desc: "How many records to return per page of data. Default #{DEFAULT_PAGE_SIZE}."
      end
      
      # For limiting list results to active records only or not.
      params :list_active_only do
        optional :list_active_only, type: Boolean, default: true, desc: "Whether or not to limit list results to only active records. Default true."
      end
      
      # Helper for applying the pagination parameters.
      def apply_pagination(data)
        data = data.paginate(page: params[:page], per_page: params[:limit])
      end
      
      # Select a single record of type clazz by ID, optionally ignoring scoping.
      # 
      def find_by_id(clazz, id)
        clazz.find(id)
      end
      
      # Select data for generic "/clazz/list" endpoints. Will all columns by default, but can be overriden
      # by select_options 
      def list_endpoint(clazz, select_options = nil, base_record_set: nil)
        if base_record_set
          records = base_record_set
        else
          records = clazz.all
        end

        records = apply_pagination(records)

        if select_options
          records.as_json(select_options)
        else
          records
        end
      end
      
      # Generic "/clazz/create" endpoints. Will return { success: true, id: Integer, error: null } on success,
      # and { success: false, id: nil, error: String } on failure.
      def create_endpoint(clazz, params, additional_params: nil)
        declared_params = declared(params, include_missing: false)

        if additional_params
          declared_params = declared_params.merge(additional_params)
        end
        
        success = false
        error = nil
        
        model = clazz.new(declared_params)
        return active_record_invalid(model, :create) unless model.valid?
        
        begin
          success = model.save
          
          unless success
            error = model.errors
          end
        rescue => e
          error = e.message
        end
        
        {
          success: success,
          id: model.id,
          error: error
        }
      end
      
      # Generic "/clazz/:id/update" endpoints. Will return { success: true, error: null } on success,
      # and { success: false, error: String } on failure.
      def update_endpoint(clazz, params)
        declared_params = declared(params, include_missing: false)

        success = false
        error = nil
        
        model = find_by_id(clazz, params[:id])
        model.assign_attributes(declared_params)
        return active_record_invalid(model, :update) unless model.valid?
        
        begin
          success = model.save
          
          unless success
            error = model.errors
          end
        rescue => e
          error = e.message
        end
        
        {
          success: success,
          error: error
        }
      end

    end
  
  end
end
