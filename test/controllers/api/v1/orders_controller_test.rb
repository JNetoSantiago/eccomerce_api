require 'test_helper'

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! 'localhost:3000'
    @order = orders(:one)
  end

  test 'should forbbiden orders for unlogged' do
    get api_v1_orders_url, as: :json
    assert_response :forbidden
  end

  test 'should show orders' do
    get api_v1_orders_url,
    headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) },
    as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal @order.user.orders.count, json_response.dig(:data).count
  end

  test 'should show order' do
    get api_v1_order_url(@order),
    headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) },
    as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    include_product_attr = json_response.dig(:included, 0, :attributes)
    assert_equal @order.products.first.title, include_product_attr.dig(:title)
  end
end
