require 'test_helper'

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! 'localhost:3000'
    @product = products(:one)
  end

  test 'should list all products' do
    get api_v1_products_url, as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)

    assert_not_nil json_response.dig(:links, :first)
    assert_not_nil json_response.dig(:links, :last)
    assert_not_nil json_response.dig(:links, :prev)
    assert_not_nil json_response.dig(:links, :next)
  end

  test 'should list all products filtering by title' do
    get "#{api_v1_products_url}?q[title_cont]=#{@product.title}", as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)

    assert_equal json_response.dig(:data).count, 1
    assert_equal @product.id.to_s, json_response.dig(:data, 0, :id)
  end

  test 'should list all published products' do
    get "#{api_v1_products_url}?q[published_true]=true", as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)

    assert_equal json_response.dig(:data).count, 2
    assert_equal [products(:one).id.to_s, products(:two).id.to_s], [json_response.dig(:data, 0, :id), json_response.dig(:data, 1, :id)]
  end

  test 'should list for price less than or equal to 299.90' do
    get "#{api_v1_products_url}?q[price_lteq_any]=299.90", as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal json_response.dig(:data).count, 1
    assert_equal products(:one).id.to_s, json_response.dig(:data, 0, :id)
  end

  test 'should list for price greater than or equal to 500' do
    get "#{api_v1_products_url}?q[price_gteq_any]=500", as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal json_response.dig(:data).count, 2
    assert_equal [products(:two).id.to_s, products(:three).id.to_s], [json_response.dig(:data, 0, :id), json_response.dig(:data, 1, :id)]
  end

  test 'should list for range price' do
    get "#{api_v1_products_url}?q[price_lteq_any]=600&q[price_gteq_any]=500", as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal json_response.dig(:data).count, 1
    assert_equal products(:three).id.to_s, json_response.dig(:data, 0, :id)
  end

  test 'should list for user' do
    get "#{api_v1_products_url}?q[user_id_eq]=#{users(:one).id.to_s}", as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal json_response.dig(:data).count, 1
    assert_equal products(:one).id.to_s, json_response.dig(:data, 0, :id)
  end

  test 'should list for category' do
    get "#{api_v1_products_url}?q[category_id_eq]=#{categories(:one).id.to_s}", as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal json_response.dig(:data).count, 1
    assert_equal products(:one).id.to_s, json_response.dig(:data, 0, :id)
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
