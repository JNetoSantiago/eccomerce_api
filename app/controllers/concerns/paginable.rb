# frozen_string_literal: true

# module for generate links in JSON api format
module Paginable
  protected

  def get_links_serializer_options_(pagy_metadata)
    {
      first: pagy_metadata[:first_url],
      last: pagy_metadata[:last_url],
      prev: pagy_metadata[:prev_url],
      next: pagy_metadata[:next_url]
    }
  end
end
