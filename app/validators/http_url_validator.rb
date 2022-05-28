class HttpUrlValidator < ActiveModel::EachValidator

  def url_valid?(value)
    uri = URI.parse(value)
    (uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    unless value.present? && url_valid?(value)
      record.errors.add(attribute, "is not a valid HTTP URL")
    end
  end

end
