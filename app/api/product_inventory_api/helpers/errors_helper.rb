module ProductInventoryApi
  module Helpers
    
    # Contains a helper for raising API errors in our standardized format.
    module ErrorsHelper
      extend Grape::API::Helpers

      def user_not_authenticated
        do_error!('auth', 401, 'Only authenticated users can access this resource. Did you remember to pass an email and token?')
      end
      
      def do_error!(type, code, message, details: [])
        code ||= 500;
        
        error = {
          type: type || 'generic',
          code: code.to_s,
          message: message || '',
          details: details || []
        }
        error!(error, code)
      end
      
      def active_record_invalid(record, action, parent_fieldset: nil)
        details = record.errors.messages.map do |field, errors|
          field_name = parent_fieldset ? "#{parent_fieldset}[#{field}]" : field
          { field: field_name, messages: errors }
        end
        
        do_error!('field', 500, "Cannot #{action} the #{record.class.name}.", details: details)
      end
      
    end
    
  end
end
