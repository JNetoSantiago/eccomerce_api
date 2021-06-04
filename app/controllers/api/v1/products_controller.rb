
module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show]
      before_action :check_login, only: [:create]

      # GET /products
      def index
        @products = Product.all
        render json: ProductSerializer.new(@products).serializable_hash
      end

      # GET /product/:id
      def show
        render json: ProductSerializer.new(@product).serializable_hash
      end

      # POST /products
      def create
        @product = current_user.products.build(product_params)
        if @product.save!
          render json: ProductSerializer.new(@product).serializable_hash, status: :created
        else
          render json: { errors: @product.errors }, status: :unprocessable_entity
        end
      end

      private
      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:title, :price, :published, :category_id, :user_id)
      end

      protected
      def check_login
        head :forbidden unless self.current_user
      end
    end
  end
end