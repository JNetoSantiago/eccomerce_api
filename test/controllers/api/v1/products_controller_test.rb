require 'test_helper'

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! 'localhost:3000'
    @product = products(:one)
  end

  test 'should show product' do
    get api_v1_product_url(@product), as: :json
    assert_response :success
    
    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal @product.title, json_response.dig(:data, :attributes, :title)
  end
end
