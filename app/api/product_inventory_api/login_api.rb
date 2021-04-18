module ProductInventoryApi
  
  class LoginApi < Grape::API
    
    helpers ProductInventoryApi::Helpers::RoutesHelper
    helpers ProductInventoryApi::Helpers::AuthHelper
    
    desc "Authenticate using basic authentication header"
     http_basic do |email, password|
      @user = User.find_by_email(email)
      @user && @user.valid_password?(password)
    end
    post :auth do 
      if @user 
        { token: token(@user) }
      else
        return {message: "User not authenticated"}
      end
    end
    
  end
end