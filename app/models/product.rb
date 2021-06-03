class Product < ApplicationRecord
  # relationships
  belongs_to :user
  belongs_to :category

  # validations
  validates :title, :user_id, :category_id, :published, presence: true
  validates :price, numericality: { greather_than_or_equal_to: 0 }, presence: true
end
