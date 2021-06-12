# frozen_string_literal: true

require 'test_helper'

class PlacementTest < ActiveSupport::TestCase
  setup do
    @placement = placements(:one)
  end

  test 'decreases the product quantity by the placement quantity' do
    assert_difference '@placement.product.quantity', -@placement.quantity do
      @placement.decrement_product_quantity!
    end
  end
end
