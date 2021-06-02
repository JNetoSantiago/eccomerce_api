module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :check_owner, only: [:update, :destroy]

      # GET /user/:id
      def show
        render json: @user
      end

      # POST /users
      def create
        @user = User.new user_params

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /user/:id
      def update
        if @user.update(user_params)
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /user/:id
      def destroy
        @user.destroy
        head 204
      end

      private
      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email, :password)
      end

      protected
      def check_owner
        head :forbidden unless @user.id == current_user&.id
      end
    end
  end
end