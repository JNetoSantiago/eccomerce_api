# frozen_string_literal: true

class ProductSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :published

  # relationships
  belongs_to :user
  belongs_to :category

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour
end
