require "test_helper"

class UserTest < ActiveSupport::TestCase
  # I didn't test every validator, in general I don't think there's a ton of value in that but I did want to set up the basic
  # tests and wanted to see how the new default rails testing harnesses work 

  # if a validator is really important I think adding test to ensure that is good but for the ske of time I'll move on

  test "email is required" do 
    user = User.new(email: nil, shop_name: "Test Shop", shop_domain: "testdomain")

    assert !user.valid? 
  end

  test "email length requirements" do 
    long_email = ""
    101.times.each { long_email += "b"}
    too_short = User.new(email: "aa", name: "Test", shop_name: "Test Shop", shop_domain: "testdomain")
    too_long = User.new(email: long_email, name: "Test", shop_name: "Test Shop", shop_domain: "testdomain")
    just_right = User.new(email: "a@a.com", name: "Test", shop_name: "Test Shop", shop_domain: "testdomain")

    assert !too_short.valid? 
    assert !too_long.valid? 
    assert just_right.valid?
  end

  test "shop name is required" do 
    user = User.new(email: "test@test.com", name: "Test", shop_name: nil, shop_domain: "testdomain")

    assert !user.valid? 
  end

  test "shop domain is required" do 
    user = User.new(email: "test@test.com", name: "Test", shop_name: "test shop", shop_domain: nil)

    assert !user.valid? 
  end

  test "can create a valid user" do 
    user = User.new(email: "test@test.com", name: "Test", shop_name: "test shop", shop_domain: "testcom")

    assert user.valid? 
  end
end
