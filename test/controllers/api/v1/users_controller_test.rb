module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        host! 'localhost:3000'
        @user = users(:one)
      end

      test "should show user" do
        get api_v1_user_url(@user), as: :json
        assert_response :success

        json_response = JSON.parse(self.response.body)
        assert_equal @user.email, json_response['email']
      end

      test "should be able to create a user" do
        assert_difference "User.count" do
          post api_v1_users_url, 
          params: { user: { email: 'so_and_so@email.com', password: '123456' } },
          as: :json
        end

        assert_response :created
      end
    end
  end
end