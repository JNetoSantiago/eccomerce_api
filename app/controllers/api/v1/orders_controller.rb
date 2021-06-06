module Api
  module V1
    class OrdersController < ApplicationController
      before_action :check_login, only: [:index, :show]

      # GET /orders
      def index
        render json: OrderSerializer.new(current_user.orders).serializable_hash
      end

      # GET /order/:id
      def show
        order = current_user.orders.find(params[:id])
        if order
          options = { include: [:products] }
          render json: OrderSerializer.new(order, options).serializable_hash
        else
          head 404
        end
      end

      protected
      def check_login
        head :forbidden unless self.current_user
      end
    end
  end
end
