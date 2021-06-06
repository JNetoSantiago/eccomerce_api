module Api
  module V1
    class OrdersController < ApplicationController
      before_action :order_params, only: [:create]
      before_action :check_login, only: [:index, :show, :create]

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

      # POST /orders
      def create
        order = current_user.orders.create(order_params)

        if order.save
          OrderMailer.send_confirmation(order).deliver
          render json: order, status: :created
        else
          render json: { errors: order.errors }, status: :unprocessable_entity
        end
      end

      protected
      def check_login
        head :forbidden unless self.current_user
      end

      private
      def order_params
        params.require(:order).permit(:total, product_ids: [])
      end
    end
  end
end
