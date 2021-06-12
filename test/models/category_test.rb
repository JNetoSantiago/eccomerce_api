# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'category valid must be valid' do
    assert_difference 'Category.count', 1 do
      Category.create description: 'category name'
    end
  end

  test 'category without description must be invalid' do
    category = Category.new description: nil
    assert_not category.valid?
  end

  test 'category with not uniqueness description must be invalid' do
    category = Category.new description: categories(:one).description
    assert_not category.valid?
  end

  test 'category without status must be invalid' do
    category = Category.new description: 'category name', status: nil
    assert_not category.valid?
  end

  test 'call func change status when disabled must be turned in enabled' do
    category = Category.create description: 'category invalid', status: 0
    assert_equal category.status, 'disabled'

    category.change_status
    assert_equal category.status, 'enabled'
  end

  test 'call func change status when enabled must be turned in disabled' do
    category = Category.create description: 'category invalid', status: 1
    assert_equal category.status, 'enabled'

    category.change_status
    assert_equal category.status, 'disabled'
  end
end
