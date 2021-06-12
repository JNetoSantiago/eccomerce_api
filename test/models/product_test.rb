# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'should have positive price' do
    product = products(:one)
    product.price = -1
    assert_not product.valid?
  end

  test 'product with invalid title should be invalid' do
    product = Product.new(
      title: nil,
      price: 120.90,
      published: true,
      user_id: users(:one).id,
      category_id: categories(:one).id
    )
    assert_not product.valid?
  end

  test 'product with invalid price should be invalid' do
    product = Product.new(
      title: 'New Product',
      price: nil,
      published: true,
      user_id: users(:one).id,
      category_id: categories(:one).id
    )
    assert_not product.valid?
  end

  test 'product with invalid user_id should be invalid' do
    product = Product.new(
      title: 'New Product',
      price: 120.90,
      published: true,
      user_id: nil,
      category_id: categories(:one).id
    )
    assert_not product.valid?
  end

  test 'product with invalid category_id should be invalid' do
    product = Product.new(
      title: 'New Product',
      price: 120.90,
      published: true,
      user_id: users(:one).id,
      category_id: nil
    )
    assert_not product.valid?
  end
end
