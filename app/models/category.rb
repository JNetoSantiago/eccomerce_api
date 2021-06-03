class Category < ApplicationRecord
  # relationships
  has_many :products, dependent: :destroy

  # validations
  validates :description, presence: true
  validates :description, uniqueness: true
  validates :status, presence: true

  # enums
  enum status: [:disabled, :enabled]


  def change_status
    case status
    when 'enabled'
      self.update(status: :disabled)
    when 'disabled'
      self.update(status: :enabled)
    end
  end
end
