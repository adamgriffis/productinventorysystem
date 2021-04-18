ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

require 'factory_bot_rails'

class ActiveSupport::TestCase
  FactoryBot.find_definitions

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Add more helper methods to be used by all tests here...

  def generate_jwt_token(user)
    payload = {
      exp: Time.now.to_i + 60 * 60,
      iat: Time.now.to_i,
      iss: ENV['JWT_ISSUER'],
      user: {
        id: user.id
      }
    }
    JWT.encode payload, ENV['JWT_SECRET'], 'HS256'
  end

  def find_or_create_user(user_symbol)
    user = User.where(email: "#{user_symbol}@test.com").first

    user ||= FactoryBot.create(user_symbol)
  end
end
