class ProductStyle < ApplicationRecord
  self.table_name = :styles
  
  validates :name, presence: true, length: {minimum: 1}
  validates_uniqueness_of :name
end
