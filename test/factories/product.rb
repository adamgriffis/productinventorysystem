# Read about fixtures at https://api.rubyonrails.org/classes/ActiveRecord/FixtureSet.html
require 'test_helper'

FactoryBot.define do
  factory :clothing, class: Product do 
    name {"Clothing Product"}
    description {"My Text"}
    shipping_price_cents {100}
    note {"My Note"}
    url {"myrul.com/resource"}
    user { User.where(email: "adam@test.com").first || FactoryBot.create(:adam) }
    product_brand { FactoryBot.create(:adams_clothing) }
    product_style { FactoryBot.create(:style_one) }
    product_type { FactoryBot.create(:type_one) }
  end

  factory :toy, class: Product do 
    name {"Toy Product"}
    description {"My Text"}
    shipping_price_cents {100}
    note {"My Note"}
    url {"myrul.com/resource"}

    user { User.where(email: "dipper@test.com").first || FactoryBot.create(:dipper) }
    product_brand { FactoryBot.create(:dippers_toys) }
    product_style { FactoryBot.create(:style_two) }
    product_type { FactoryBot.create(:type_two) }
  end
end