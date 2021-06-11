class ProductSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :price, :published

  # relationships
  belongs_to :user
  belongs_to :category

  cache_options enabled: true, cache_length: 12.hours
end
