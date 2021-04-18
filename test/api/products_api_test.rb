class ProductsApiTest < ActionDispatch::IntegrationTest

  setup do 
    @user = FactoryBot.create(:adam)
    @jwt_token = generate_jwt_token(@user)

    @clothing = FactoryBot.create(:clothing)
    @toy = FactoryBot.create(:toy)
  end

  test "GET /api/products" do

    get "/api/products", headers: { "Authorization": "Bearer #{@jwt_token}"}
    
    assert_response :success
    assert !response.body.nil?

    assert JSON.parse(response.body).include?(@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
    assert JSON.parse(response.body).length == 1
  end

  test "GET /api/products/search" do # cases where we find results

    get "/api/products/search", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {type: @clothing.type}
    
    assert_response :success
    assert !response.body.nil?

    assert JSON.parse(response.body).include?(@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
    assert JSON.parse(response.body).length == 1

    get "/api/products/search", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {type: @clothing.type, style: @clothing.style}

    assert_response :success
    assert !response.body.nil?

    assert JSON.parse(response.body).include?(@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
    assert JSON.parse(response.body).length == 1

    get "/api/products/search", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {brand: @clothing.brand}
    
    assert_response :success
    assert !response.body.nil?

    assert JSON.parse(response.body).include?(@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
    assert JSON.parse(response.body).length == 1

    @new_clothing = @clothing.dup
    @new_clothing.style = "New Style"
    @new_clothing.save

    # new clothing will be excluded because of the style search
    get "/api/products/search", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {brand: @clothing.brand, style: @clothing.style}
    
    assert_response :success
    assert !response.body.nil?

    assert JSON.parse(response.body).include?(@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
    assert JSON.parse(response.body).length == 1
  end

  test "GET /api/products/id" do

    get "/api/products/#{@clothing.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}

    assert_response :success
    assert !response.body.nil?

    assert JSON.parse(response.body) == (@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
  end

  test "GET /api/products/id fails due to user" do

    get "/api/products/#{@toy.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}
    
    assert_response :error
  end

  test "POST /api/products success" do

    post "/api/products", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {name: "New Product", type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: "200", note: "New Note", desc: "New Desc"}
  
    assert_response :success

    prod = Product.find_by(name: "New Product")
    assert !prod.nil?
    assert prod.type == "New Type"
    assert prod.brand == "New Brand"
    assert prod.style == "New Style"
  end

  test "POST /api/products failures" do

    post "/api/products", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {name: @clothing.name, type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: "-1", note: "New Note", desc: "New Desc"}
  
    assert_response :error

    assert JSON.parse(@response.body)['type'] == 'field'
    assert JSON.parse(@response.body)['code'] == '500'
    assert JSON.parse(@response.body)['details'][0]['messages'][0] == 'must be greater than or equal to 0'

    post "/api/products", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: "200", note: "New Note", desc: "New Desc"}
  
    assert_response :error
  end


  test "PUT /api/products/id success" do

    put "/api/products/#{@clothing.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {name: "New Clothing", type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: "200", note: "New Note", desc: "New Desc"}
  
    assert_response :success

    prod = @clothing.reload
    assert !prod.nil?
    assert prod.name == "New Clothing"
    assert prod.type == "New Type"
    assert prod.brand == "New Brand"
    assert prod.style == "New Style"
  end

  test "PUT /api/products failures" do
    put "/api/products/#{@clothing.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: -10, note: "New Note", desc: "New Desc"}
  
    assert_response :error
  end

end
