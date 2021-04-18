class InventoriesApiTest < ActionDispatch::IntegrationTest

  setup do 
    @user = FactoryBot.create(:adam)
    @jwt_token = generate_jwt_token(@user)

    @clothing_small = FactoryBot.create(:clothing_small)
    @clothing_large = FactoryBot.create(:clothing_large)

    @toy_small = FactoryBot.create(:toy_small)
    @toy_xlarge = FactoryBot.create(:toy_xlarge)
  end

  test "GET /api/inventories" do

    get "/api/inventories", headers: { "Authorization": "Bearer #{@jwt_token}"}
    
    assert_response :success
    assert !response.body.nil?

    assert JSON.parse(response.body).include?(@clothing_small.as_json({only: [:id, :product_id, :quantity, :color, :size, :price_cents, :sku, :sale_price_cents]}))
    assert JSON.parse(response.body).include?(@clothing_large.as_json({only: [:id, :product_id, :quantity, :color, :size, :price_cents, :sku, :sale_price_cents]}))
    assert JSON.parse(response.body).length == 2 # toy inventories are excluded because they're for another use
  end

  test "GET /api/inventories/:id" do

    get "/api/inventories/#{@clothing_small.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}
    
    assert_response :success
    assert !response.body.nil?

    assert JSON.parse(response.body) == (@clothing_small.as_json({only: [:id, :product_id, :quantity, :color, :size, :price_cents, :sale_price_cents, :sku, :weight, :notes, :height, :width, :length, :cost_cents]}))
  end

  test "GET /api/inventories/:id -- fails because of user" do 

    get "/api/inventories/#{@toy_small.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}
    
    assert_response :error
  end

  test "POST /api/inventories success" do

    post "/api/inventories", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {
        product_id: @clothing_small.product.id, 
        quantity: 100,
        color: "Red",
        size: "M",
        sku: "CLTMED",
        weight: 10,
        length: 3,
        width: 4,
        height: 5,
        note: 'This is the medium',
        price_cents: 100,
        sale_price_cents: 50,
        cost_cents: 20
      }
  
    assert_response :success

    inv = Inventory.find_by(sku: "CLTMED")
    assert !inv.nil?
    assert inv.size == "M"
    assert inv.color == "Red"
    assert inv.product == @clothing_small.product
  end

  test "POST /api/inventories failues" do

    post "/api/inventories", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {
        #product_id: @clothing_small.product.id,  -- not product
        quantity: 100,
        color: "Red",
        size: "M",
        sku: "CLTMED",
        weight: 10,
        length: 3,
        width: 4,
        height: 5,
        note: 'This is the medium',
        price_cents: 100,
        sale_price_cents: 50,
        cost_cents: 20
      }
  
    assert_response :error 

    post "/api/inventories", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {
        product_id: @clothing_small.product.id, 
        quantity: 100,
        color: "Red",
        size: "M",
        sku: @clothing_small.sku, # duplicate SKU
        weight: 10,
        length: 3,
        width: 4,
        height: 5,
        note: 'This is the medium',
        price_cents: 100,
        sale_price_cents: 50,
        cost_cents: 20
      }
  
    assert_response :error

    post "/api/inventories", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {
        product_id: @clothing_small.product.id, 
        quantity: 100,
        color: "Red",
        size: "M",
        sku: 'cthsku', # duplicate SKU
        weight: 10,
        length: 3,
        width: 4,
        height: 5,
        note: 'This is the medium',
        price_cents: -10,# negative price 
        sale_price_cents: 50,
        cost_cents: 20 
      }
  
    assert_response :error
  end

  test "PUT /api/inventories/id success" do

    put "/api/inventories/#{@clothing_small.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {
        quantity: 100,
        color: "Orange",
        price_cents: 200,
        sale_price_cents: 30,
        cost_cents: 10
      }
  
    assert_response :success

    inv = @clothing_small.reload
    assert !inv.nil?
    assert inv.size == "S"
    assert inv.quantity == 100
    assert inv.color == "Orange"
    assert inv.price_cents == 200
    assert inv.sale_price_cents == 30
    assert inv.cost_cents == 10
    assert inv.product == @clothing_small.product
  end

  test "PUT /api/inventories failues" do    

    put "/api/inventories/#{@clothing_small.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {
        quantity: -10, # negative quantity 
        color: "Orange",
        price_cents: 200,
        sale_price_cents: 30,
        cost_cents: 10
      }
  
    assert_response :error 

    put "/api/inventories/#{@clothing_small.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {
        quantity: 10,
        color: "Orange",
        product_id: nil, # nil out product
        price_cents: 200,
        sale_price_cents: 30,
        cost_cents: 10
      }
  
    assert_response :error 


    put "/api/inventories/#{@clothing_small.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {
        quantity: 10,
        color: "Orange",
        price_cents: -200, # native price
        sale_price_cents: 30,
        cost_cents: 10
      }
  
    assert_response :error 
  end

  # test "GET /api/products/search" do # cases where we find results

  #   get "/api/products/search", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {type: @clothing.type}
    
  #   assert_response :success
  #   assert !response.body.nil?

  #   assert JSON.parse(response.body).include?(@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
  #   assert JSON.parse(response.body).length == 1

  #   get "/api/products/search", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {type: @clothing.type, style: @clothing.style}

  #   assert_response :success
  #   assert !response.body.nil?

  #   assert JSON.parse(response.body).include?(@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
  #   assert JSON.parse(response.body).length == 1

  #   get "/api/products/search", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {brand: @clothing.brand}
    
  #   assert_response :success
  #   assert !response.body.nil?

  #   assert JSON.parse(response.body).include?(@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
  #   assert JSON.parse(response.body).length == 1

  #   @new_clothing = @clothing.dup
  #   @new_clothing.style = "New Style"
  #   @new_clothing.save

  #   # new clothing will be excluded because of the style search
  #   get "/api/products/search", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {brand: @clothing.brand, style: @clothing.style}
    
  #   assert_response :success
  #   assert !response.body.nil?

  #   assert JSON.parse(response.body).include?(@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
  #   assert JSON.parse(response.body).length == 1
  # end

  # test "GET /api/products/id" do

  #   get "/api/products/#{@clothing.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}

  #   assert_response :success
  #   assert !response.body.nil?

  #   assert JSON.parse(response.body) == (@clothing.as_json({only: [:id, :description, :created_at, :updated_at, :url], methods: [:product_name, :type, :style, :brand, :shipping_price, :note]}))
  # end

  # test "GET /api/products/id fails due to user" do

  #   get "/api/products/#{@toy.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}
    
  #   assert_response :error
  # end

  # test "POST /api/products success" do

  #   post "/api/products", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {name: "New Product", type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: "200", note: "New Note", desc: "New Desc"}
  
  #   assert_response :success

  #   prod = Product.find_by(name: "New Product")
  #   assert !prod.nil?
  #   assert prod.type == "New Type"
  #   assert prod.brand == "New Brand"
  #   assert prod.style == "New Style"
  # end

  # test "POST /api/products failures" do

  #   post "/api/products", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {name: @clothing.name, type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: "200", note: "New Note", desc: "New Desc"}
  
  #   assert_response :error

  #   assert JSON.parse(@response.body)['type'] == 'field'
  #   assert JSON.parse(@response.body)['code'] == '500'
  #   assert JSON.parse(@response.body)['details'][0]['messages'][0] == 'has already been taken'

  #   post "/api/products", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: "200", note: "New Note", desc: "New Desc"}
  
  #   assert_response :error
  # end


  # test "PUT /api/products/id success" do

  #   put "/api/products/#{@clothing.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {name: "New Clothing", type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: "200", note: "New Note", desc: "New Desc"}
  
  #   assert_response :success

  #   prod = @clothing.reload
  #   assert !prod.nil?
  #   assert prod.name == "New Clothing"
  #   assert prod.type == "New Type"
  #   assert prod.brand == "New Brand"
  #   assert prod.style == "New Style"
  # end

  # test "PUT /api/products failures" do
  #   put "/api/products/#{@clothing.id}", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {type: "New Type", style: "New Style", brand: "New Brand", shipping_price_cents: "200", note: "New Note", desc: "New Desc"}
  
  #   assert_response :error
  # end

end
