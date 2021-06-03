module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: [:show, :update]

      # GET /category/:id
      def show
        render json: @category
      end

      # POST /categories
      def create
        @category = Category.new category_params
        if @category.save
          render json: @category, status: :created
        else
          render json: @category.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /category/:id
      def update
        if @category.update(category_params)
          render json: @category, status: :ok
        else
          render json: @category.errors, status: :unprocessable_entity
        end
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