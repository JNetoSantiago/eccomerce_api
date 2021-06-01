class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :email, email: true
  validates :password_digest, presence: true
end
