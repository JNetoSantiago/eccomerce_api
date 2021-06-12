# frozen_string_literal: true

module Api
  module V1
    class TokensControllerTest < ActionDispatch::IntegrationTest
      setup do
        host! 'localhost:3000'
        @user = users(:one)
      end

      test 'should get jwt token' do
        post api_v1_tokens_url,
             params: { user: { email: @user.email, password: 'g00d_pa$$' } },
             as: :json

        assert_response :success

        json_response = JSON.parse(response.body)
        assert_not_nil json_response['token']
      end

      test 'should not get jwt token' do
        post api_v1_tokens_url,
             params: { user: { email: @user.email, password: 'b@d_pa$$' } },
             as: :json

        assert_response :unauthorized
      end
    end
  end
end
