# frozen_string_literal: true

class HttpUrlValidator < ActiveModel::EachValidator
  def url_valid?(value)
    uri = URI.parse(value)
    (uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'is not a valid HTTP URL') unless value.present? && url_valid?(value)
  end
end
