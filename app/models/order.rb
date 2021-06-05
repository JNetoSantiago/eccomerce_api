class Order < ApplicationRecord
  # relationships
  belongs_to :user

  # validations
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true
end
