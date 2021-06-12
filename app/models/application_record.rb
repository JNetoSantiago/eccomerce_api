# frozen_string_literal: true

# model base
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
