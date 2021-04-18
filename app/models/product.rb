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

  scope :search_style, -> (style_string) do
    result = self

    unless style_string.blank?
      style = ProductStyle.where(name: style_string).first

      if style.nil? # did we find the style?
        result = result.where("1=0")
      else
        result = result.where(product_style: style)
      end
    end

    result
  end

  scope :search_brand, -> (brand_string) do 
    result = self

    unless brand_string.blank?
      brand = ProductBrand.where(name: brand_string).first

      if brand.nil? # did we find the brand?
        result = result.where("1=0")
      else
        result = result.where(product_brand: brand)
      end
    end

    result
  end

  scope :search_type, -> (type_string) do 
    result = self

    unless type_string.blank?
      type = ProductType.where(name: type_string).first

      if type.nil? # did we find the brand?
        result = result.where("1=0")
      else
        result = result.where(product_type: type)
      end
    end

    result
  end

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
