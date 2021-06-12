# frozen_string_literal: true

# model for placements table
class Placement < ApplicationRecord
  # relashionships
  belongs_to :order
  belongs_to :product, inverse_of: :placements

  # callbacks
  after_create :decrement_product_quantity!

  def decrement_product_quantity!
    product.update(quantity: product.quantity - quantity)
  end
end
