# frozen_string_literal: true

module Api
  module V1
    # controller for tokens
    class TokensController < ApplicationController
      # POST /tokens
      def create
        @user = User.find_by(email: user_params[:email])
        if @user&.authenticate(user_params[:password])
          response.set_cookie(
            :eccomerce_cookie,
            {
              value: JsonWebToken.encode(user_id: @user.id),
              expires: 24.hours.from_now,
              path: '/',
              secure: true,
              httponly: true
            }
          )
          render json: {
            token: JsonWebToken.encode(user_id: @user.id),
            email: @user.email
          }
        else
          head :unauthorized
        end
      end

      # GET /tokens/me
      def me
        if current_user
          render json: {
            user: current_user
          }
        else
          render json: nil
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
