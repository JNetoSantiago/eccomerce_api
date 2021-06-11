module Paginable
  protected
  def get_links_serializer_options_ pagy_metadata
    {
      first: pagy_metadata.dig(:first_url),
      last: pagy_metadata.dig(:last_url),
      prev: pagy_metadata.dig(:prev_url),
      next: pagy_metadata.dig(:next_url),
    }
  end
end
