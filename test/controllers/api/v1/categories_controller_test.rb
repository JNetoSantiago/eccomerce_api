# frozen_string_literal: true

module Api
  module V1
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        host! 'localhost:3000'
        @category = categories(:one)
      end

      test 'should show category' do
        get api_v1_category_url(@category.id), as: :json
        assert_response :success

        json_response = JSON.parse(response.body, symbolize_names: true)
        assert_equal @category.description, json_response.dig(:data, :attributes, :description)

        assert_equal @category.products.first.id.to_s,
                     json_response.dig(:data, :relationships, :products, :data, 0, :id)
        assert_equal @category.products.first.title, json_response.dig(:included, 0, :attributes, :title)
      end

      test 'should create category' do
        post api_v1_categories_url,
             params: { category: { description: 'new category', status: 1 } },
             as: :json

        assert_response :created
      end

      test 'should not create when invalid params are sent' do
        post api_v1_categories_url,
             params: { category: { status: 1 } },
             as: :json

        assert_response :unprocessable_entity
      end

      test 'should update category' do
        patch api_v1_category_url(@category),
              params: { category: { description: 'new description', status: 1 } },
              as: :json

        assert_response :success
      end

      test 'should not update when invalid params are sent' do
        patch api_v1_category_url(@category),
              params: { category: { description: nil, status: 1 } },
              as: :json

        assert_response :unprocessable_entity
      end

      test 'should destroy category' do
        assert_difference 'Category.count', -1 do
          delete api_v1_category_url(@category), as: :json
        end
        assert_response :no_content
      end
    end
  end
end
