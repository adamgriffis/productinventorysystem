class LoginApiTest < ActionDispatch::IntegrationTest

  test "POST /api/auth" do
    @user = find_or_create_user(:adam)
    post "/api/auth/", headers: {"Authorization": ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, '123greetings')}
    
    assert !response.body.nil?

    token = JSON.parse(response.body)['token']

    options = { algorithm: 'HS256', iss: ENV['JWT_ISSUER'] }
    payload, header = JWT.decode token, ENV['JWT_SECRET'], true, options

    # assert we've been given a valid JWT token
    assert payload['iss'] == ENV['JWT_ISSUER']
    assert payload['user']['id'] == @user.id
  end

  test "Failure POST /api/auth" do
    @user = find_or_create_user(:adam)
    post "/api/auth/", headers: {"Authorization": ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'ba;jablahb')}
    
    assert response.body == ""
  end

end