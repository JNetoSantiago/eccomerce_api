# frozen_string_literal: true

# model for categories table
class Category < ApplicationRecord
  # relationships
  has_many :products, dependent: :destroy

  # validations
  validates :description, presence: true
  validates :description, uniqueness: true
  validates :status, presence: true

  # enums
  enum status: { disabled: 0, enabled: 1 }

  def change_status
    case status
    when 'enabled'
      update(status: :disabled)
    when 'disabled'
      update(status: :enabled)
    end
  end
end
