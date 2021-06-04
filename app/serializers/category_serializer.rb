class CategorySerializer
  include FastJsonapi::ObjectSerializer
  attributes :description, :status

  # relationships
  has_many :products
end
