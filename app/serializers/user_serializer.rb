class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email

  # relationships
  has_many :products
end
