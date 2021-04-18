class Inventory < ApplicationRecord
  acts_as_tenant(:user) # user is the tenant for products / inventory

  belongs_to :user
  belongs_to :product

  validates :size, presence: true, length: {minimum: 1}
  validates :color, presence: true, length: {minimum: 1}
  validates_presence_of  :quantity
  validates_presence_of  :sku
  validates_presence_of  :weight
  validates_presence_of  :length
  validates_presence_of  :width
  validates_presence_of  :height
  validates_presence_of  :price_cents
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :sale_price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :cost_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  validates :width, numericality: { greater_than: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0 }
  validates :length, numericality: { greater_than: 0 }
  validates :height, numericality: { greater_than: 0 }

  def update_quantity!(new_quantity)
    self.with_lock do # this creates a FOR UPDATE lock and a transaction for the item
      raise "Cannot adjust quantity to be less than 0" if new_quantity < 0 

      self.update!(quantity: new_quantity) # validation will catch the case where this will make quantity less than 0
    end
  end

  def adjust_quqnaity!(adjustment)
    # we need to lock before we read the quantity because otherwise the adjustment could be applying to an old quantity
    self.with_lock do # this creates a FOR UPDATE lock and a transaction for the item, the nested transaction in update_quantity doesn't matter, the outside transaction will "win"
      existing_quantity = self.quantity
      new_quantity = existing_quantity + adjustment

      self.update!(quantity: new_quantity) # validation will catch the case where this will make quantity less than 0
    end
  end
end
