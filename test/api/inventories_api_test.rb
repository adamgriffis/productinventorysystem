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
  
    assert_response 400

    post "/api/inventories", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {
        product_id: @clothing_small.product.id, 
        quantity: 100,
        color: "Red",
        size: "M",
        sku: @clothing_small.sku, 
        weight: -1, # negative weight
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

  test "PUT /api/inventories/id/adjust success" do

    expected_qty = @clothing_small.quantity - 5
    put "/api/inventories/#{@clothing_small.id}/adjust", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {adjustment: -5}
  
    assert_response :success

    inv = @clothing_small.reload
    assert !inv.nil?
    assert inv.quantity == expected_qty
    
    expected_qty = @clothing_small.quantity + 10
    put "/api/inventories/#{@clothing_small.id}/adjust", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {adjustment: 10}
  
    assert_response :success

    inv = @clothing_small.reload
    assert !inv.nil?
    assert inv.quantity == expected_qty
    
  end

  test "PUT /api/inventories/id/adjust failues" do    

    put "/api/inventories/#{@clothing_small.id}/adjust", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {adjustment: (@clothing_small.quantity + 1)*-1}
  
    assert_response 400

    put "/api/inventories/#{@clothing_small.id}/adjust", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {}
  
    assert_response 400
  end

  # this is a slow test, but I thought this was a really important thing to hit hard. You can make it run much faster by changing line 225 to "100.times", 
  # right now it's 10 thread executing 100 adjustments, that would make it 10 x 10 
  test "PUT /api/inventories/id/adjust with high concurrency" do 
    @clothing_small.update(quantity: 100000)

    # generate a random batch of adjustments 
    adjustments = []

    1000.times do 
      adjustments << rand(-20..20) # 100 adjusments between -10 and 30
    end

    threads = []
    fail_occurred = false

    #puts adjustments

    (0..9).each do |concurr_index|
      # start 10 concurrent threads, each will be processing 1/10 of the adjustment from above
      threads << Thread.new do
        adjustments.each_with_index do |quantity, index|
          #puts "in thread #{concurr_index} #{index}"
          if concurr_index == (index % 10) # 1 should only do 1, 2 -> 2, etc etc
            put "/api/inventories/#{@clothing_small.id}/adjust", headers: { "Authorization": "Bearer #{@jwt_token}"}, params: {adjustment: quantity}
            assert_response :success
          end
        end
      end
    end 

    threads.each(&:join)

    @clothing_small.reload

    net_adjust = adjustments.sum

    assert @clothing_small.quantity == (100000 + net_adjust)
  end

end
