class Placement < ApplicationRecord
  # relashionships
  belongs_to :order
  belongs_to :product, inverse_of: :placements

  # callbacks
  after_create :decrement_product_quantity!

  def decrement_product_quantity!
    product.decrement!(:quantity, quantity)
  end
end
