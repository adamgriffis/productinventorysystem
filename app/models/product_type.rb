class ProductType < ApplicationRecord
  self.table_name = :types
  
  validates :name, presence: true, length: {minimum: 1}
  validates_uniqueness_of :name
end
