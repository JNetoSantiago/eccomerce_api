# frozen_string_literal: true

# model for users table
class User < ApplicationRecord
  has_secure_password

  # validations
  validates :email, uniqueness: true
  validates :email, email: true
  validates :password_digest, presence: true

  # relationships
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
end
