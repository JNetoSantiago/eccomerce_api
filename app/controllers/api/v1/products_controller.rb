
module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show]

      # GET /products
      def index
        @products = Product.all
        render json: ProductSerializer.new(@products).serializable_hash
      end

      # GET /product/:id
      def show
        render json: ProductSerializer.new(@product).serializable_hash
      end

      private
      def set_product
        @product = Product.find(params[:id])
      end
    end
  end
end