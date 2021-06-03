module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: [:show, :update, :destroy]

      # GET /category/:id
      def show
        render json: CategorySerializer.new(@category).serializable_hash
      end

      # POST /categories
      def create
        @category = Category.new category_params
        if @category.save
          render json: CategorySerializer.new(@category).serializable_hash, status: :created
        else
          render json: @category.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /category/:id
      def update
        if @category.update(category_params)
          render json: CategorySerializer.new(@category).serializable_hash, status: :ok
        else
          render json: @category.errors, status: :unprocessable_entity
        end
      end

      # DELETE /category/:id
      def destroy
        @category.destroy
        head 204
      end

      private
      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:description, :status)
      end
    end
  end
end