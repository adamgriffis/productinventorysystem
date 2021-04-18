class Product < ApplicationRecord
  acts_as_tenant(:user) # user is the tenant for products / inventory

  belongs_to :user
  belongs_to :product_type, foreign_key: "type_id"
  belongs_to :product_brand, foreign_key: "brand_id"
  belongs_to :product_style, foreign_key: "style_id"

  validates_uniqueness_of :name, scope: :user_id

  validates :name, presence: true, length: {minimum: 1, maximum: 100}
  validates :user, presence: true
  validates_presence_of  :product_type
  validates_presence_of :product_brand
  validates_presence_of  :product_style

  alias_attribute :product_name, :name
  alias_attribute :shipping_price, :shipping_price_cents

  # these helpers are to allow 
  def type
    product_type.name
  end

  def type=(type_name)
    self.product_type = ProductType.find_or_create_by(name: type_name)
  end 

  def brand
    product_brand.name
  end

  def brand=(brand_name)
    self.product_brand = ProductBrand.find_or_create_by(name: brand_name)
  end 

  def style
    product_style.name
  end

  def style=(style_name)
    self.product_style = ProductStyle.find_or_create_by(name: style_name)
  end 
end
