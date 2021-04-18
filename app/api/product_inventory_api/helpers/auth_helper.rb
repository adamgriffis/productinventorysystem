module ProductInventoryApi
  module Helpers
    module AuthHelper
      extend Grape::API::Helpers
      
      def token(user)
        JWT.encode payload(user), ENV['JWT_SECRET'], 'HS256'
      end

      def payload(user)
        {
          exp: Time.now.to_i + 60 * 60,
          iat: Time.now.to_i,
          iss: ENV['JWT_ISSUER'],
          user: {
            id: user.id
          }
        }
      end

      def authenticate_jwt
        options = { algorithm: 'HS256', iss: ENV['JWT_ISSUER'] }
        bearer = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)

        payload, header = JWT.decode bearer, ENV['JWT_SECRET'], true, options

        if payload['exp'] < Time.now.to_i
          return {message: "User not authenticated"}
        end

        user_id = payload['user']['id']

        user = User.find user_id
      end
    end
  end
end
