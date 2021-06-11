class CategorySerializer
  include FastJsonapi::ObjectSerializer
  attributes :description, :status

  # relationships
  has_many :products

  cache_options enabled: true, cache_length: 12.hours
end
