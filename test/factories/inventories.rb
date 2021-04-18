# Read about fixtures at https://api.rubyonrails.org/classes/ActiveRecord/FixtureSet.html
FactoryBot.define do
  factory :clothing_small, class: Inventory do 
    
    product { Product.where(name: "Clothing Product").first || FactoryBot.create(:clothing) }
    user { User.where(email: "adam@test.com").first || FactoryBot.create(:adam) }
    quantity { 20 }
    color { 'Red' }
    size { 'S' }
    sku { 'SMCLTH' }
    weight { 7 }
    price_cents { 1000 }
    cost_cents { 500 }
    sale_price_cents { 7500 }
    length { 2}
    width { 3 }
    height { 4 }
    note { 'Note text'}
  end

  factory :clothing_large, class: Inventory do 
    
    product { Product.where(name: "Clothing Product").first || FactoryBot.create(:clothing) }
    user { User.where(email: "adam@test.com").first || FactoryBot.create(:adam) }
    quantity { 20 }
    color { 'Red' }
    size { 'L' }
    sku { 'LGCLTH' }
    weight { 10 }
    price_cents { 1200 }
    cost_cents { 500 }
    sale_price_cents { 8500 }
    length { 2}
    width { 3 }
    height { 4 }
    note { 'Note text'}
  end

  factory :toy_small, class: Inventory do 
    
    product { Product.where(name: "Toy Product").first || FactoryBot.create(:toy) }
    user { User.where(email: "dipper@test.com").first || FactoryBot.create(:dipper) }
    quantity { 20 }
    color { 'Red' }
    size { 'S' }
    sku { 'SMCTOY' }
    weight { 7 }
    price_cents { 1000 }
    cost_cents { 500 }
    sale_price_cents { 7500 }
    length { 2}
    width { 3 }
    height { 4 }
    note { 'Note text'}
  end

  factory :toy_xlarge, class: Inventory do 
    
    product { Product.where(name: "Toy Product").first || FactoryBot.create(:toy) }
    user { User.where(email: "dipper@test.com").first || FactoryBot.create(:dipper) }
    quantity { 20 }
    color { 'Blue' }
    size { 'XL' }
    sku { 'XLGTOY' }
    weight { 10 }
    price_cents { 1200 }
    cost_cents { 500 }
    sale_price_cents { 8500 }
    length { 2}
    width { 3 }
    height { 4 }
    note { 'Note text'}
  end
end