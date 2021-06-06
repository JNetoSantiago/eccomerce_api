module Api
  module V1
    class OrdersController < ApplicationController
      before_action :check_login, only: [:index]

      # GET /orders
      def index
        render json: OrderSerializer.new(current_user.orders).serializable_hash
      end

      protected
      def check_login
        head :forbidden unless self.current_user
      end
    end
  end
end
