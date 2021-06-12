# frozen_string_literal: true

# validator for email
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return record.errors.add attribute, 'is not an email' unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end
