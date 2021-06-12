# frozen_string_literal: true

# model for products table
class Product < ApplicationRecord
  # relationships
  belongs_to :user
  belongs_to :category
  has_many :placements, dependent: :destroy
  has_many :orders, through: :placements

  # validations
  validates :title, :user_id, :category_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
