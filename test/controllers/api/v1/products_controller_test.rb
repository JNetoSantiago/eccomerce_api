require 'test_helper'

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! 'localhost:3000'
    @product = products(:one)
  end

  test 'should list all products' do
    get api_v1_products_url(), as: :json
    assert_response :success
  end

  test 'should show product' do
    get api_v1_product_url(@product), as: :json
    assert_response :success
    
    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal @product.title, json_response.dig(:data, :attributes, :title)
  end

  test 'should create a product' do
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
end
