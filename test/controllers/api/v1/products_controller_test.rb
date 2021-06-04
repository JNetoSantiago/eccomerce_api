require 'test_helper'

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! 'localhost:3000'
    @product = products(:one)
  end

  test 'should list all products' do
    get api_v1_products_url, as: :json
    assert_response :success
  end

  test 'should show product' do
    get api_v1_product_url(@product), as: :json
    assert_response :success
    
    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal @product.title, json_response.dig(:data, :attributes, :title)

    assert_equal @product.user.id.to_s, json_response.dig(:data, :relationships, :user, :data, :id)
    assert_equal @product.user.email, json_response.dig(:included, 1, :attributes, :email)
    
    assert_equal @product.category.id.to_s, json_response.dig(:data, :relationships, :category, :data, :id)
    assert_equal @product.category.description, json_response.dig(:included, 0, :attributes, :description)
  end

  test 'should create product' do
    assert_difference "Product.count" do
      post api_v1_products_url,
      params: { product: { title: 'TV Lg 4k', price: 2286.63, published: true, category_id: categories(:one).id } },
      headers: { Authorization: JsonWebToken.encode(user_id: users(:one).id) },
      as: :json

      assert_response :created
    end
  end

  test 'should not create when invalid params are sent' do
    assert_no_difference "Product.count" do
      post api_v1_products_url,
      params: { product: { title: nil, price: 2286.63, published: true, category_id: categories(:one).id } },
      headers: { Authorization: JsonWebToken.encode(user_id: users(:one).id) },
      as: :json

      assert_response :unprocessable_entity
    end
  end

  test 'should forbidden create a product' do
    assert_no_difference "Product.count" do
      post api_v1_products_url,
      params: { product: { title: 'TV Lg 4k', price: 2286.63, published: true, category_id: categories(:one).id } },
      as: :json

      assert_response :forbidden
    end
  end

  test 'should update product' do
    patch api_v1_product_url(@product),
    params: { product: { title: 'new title' } },
    headers: { Authorization: JsonWebToken.encode(user_id: @product.user.id) },
    as: :json

    assert_response :success
  end

  test 'should not update when invalid params are sent' do
    patch api_v1_product_url(@product),
    params: { product: { title: nil } },
    headers: { Authorization: JsonWebToken.encode(user_id: @product.user.id) },
    as: :json

    assert_response :unprocessable_entity
  end

  test 'should not update when user is not owner' do
    patch api_v1_product_url(@product),
    params: { product: { title: nil } },
    headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id) },
    as: :json

    assert_response :forbidden
  end

  test 'should destroy product' do
    assert_difference "Product.count", -1 do
      delete api_v1_product_url(@product),
      headers: { Authorization: JsonWebToken.encode(user_id: @product.user.id) },
      as: :json
    end
    assert_response :no_content
  end

  test 'should not destroy product if is not authenticated' do
    delete api_v1_product_url(@product), as: :json

    assert_response :forbidden
  end

  test 'should not destroy product if user is not owner' do
    delete api_v1_product_url(@product), as: :json

    assert_response :forbidden
  end
end
