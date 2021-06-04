class ProductSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :price, :published

  # relationships
  belongs_to :user
  belongs_to :category
end
