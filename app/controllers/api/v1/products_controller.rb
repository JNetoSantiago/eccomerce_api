
module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show, :update, :destroy]
      before_action :check_login, only: [:create, :update, :destroy]
      before_action :check_owner, only: [:update, :destroy]

      # GET /products
      def index
        @products = Product.ransack(params[:q]).result
        render json: ProductSerializer.new(@products).serializable_hash
      end

      # GET /product/:id
      def show
        options = { include: [:user, :category] }
        render json: ProductSerializer.new(@product, options).serializable_hash
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

      # PATCH/PUT /products
      def update
        if @product.update(product_params)
          render json: ProductSerializer.new(@product).serializable_hash, status: :created
        else
          render json: { errors: @product.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /product/:id
      def destroy
        @product.destroy
        head 204
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
      
      def check_owner
        head :forbidden unless @product.user_id == current_user&.id
      end
    end
  end
end