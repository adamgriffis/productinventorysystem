class User < ApplicationRecord
  devise :database_authenticatable

  # making assumptions about certain fields being required
  validates :email, presence: true, length: {minimum: 3, maximum: 100}
  validates :name, presence: true
  validates :shop_name, presence: true
  validates :shop_domain, presence: true

  validates_uniqueness_of :email
  validates_uniqueness_of :shop_domain
end
