module Api
  module V1
    class OrdersController < ApplicationController
      include Paginable

      before_action :order_params, only: [:create]
      before_action :check_login, only: [:index, :show, :create]

      # GET /orders
      def index
        @pagy, @orders = pagy(current_user.orders)
        options = {}
        options[:links] = get_links_serializer_options_(pagy_metadata(@pagy))
        render json: OrderSerializer.new(@orders, options).serializable_hash
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
        order = Order.create! user: current_user
        order.build_placements_with_product_ids_and_quantities(order_params[:product_ids_and_quantities])

        if order.save
          OrderMailer.send_confirmation(order).deliver
          render json: order, status: :created
        else
          render json: { errors: order.errors }, status: :unprocessable_entity
        end
      rescue StandardError => e
        p e
      end

      protected
      def check_login
        head :forbidden unless self.current_user
      end

      private
      def order_params
        params.require(:order).permit(product_ids_and_quantities: [:product_id, :quantity])
      end
    end
  end
end
