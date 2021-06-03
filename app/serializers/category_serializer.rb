class CategorySerializer
  include FastJsonapi::ObjectSerializer
  attributes :description, :status
end
