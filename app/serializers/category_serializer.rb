class CategorySerializer
  include JSONAPI::Serializer
  attributes :description, :status

  # relationships
  has_many :products

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour
end
