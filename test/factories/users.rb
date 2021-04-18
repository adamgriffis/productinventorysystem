FactoryBot.define do
  factory :adam, class: User do 
    name {"Adam"}
    email {"adam@test.com"}
    shop_name {"Adam's Shop"}
    superadmin {false}
    shop_domain {"adamshop"}
    password {'123greetings'}
  end

  factory :dipper, class: User do 
    name {"Dipper"}
    email {"dipper@test.com"}
    shop_name {"Dipper's Shop"}
    superadmin {false}
    shop_domain {"dippershop"}
    password {'123dipper'}
  end
end
