class HttpUrlValidator < ActiveModel::EachValidator

  def url_valid?(value)
    uri = URI.parse(value)
    (uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)) && !uri.host.nil?
    # uri.kind_of?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    unless value.present? && url_valid?(value)
      record.errors.add(attribute, "is not a valid HTTP URL")
    end
  end

end
# class UrlValidator < ActiveModel::EachValidator

  # def validate_each(record, attribute, value)
  #   record.errors[attribute] << (options[:message] || "must be a valid URL") unless url_valid?(value)
  # end
  # value.present? &&

#   def validate_each(record, attribute, value)
#       unless value.present? && url_valid?(value)
#         record.errors.add(attribute, 'is not a valid HTTP URL')
#       end
#   end
#
#   def url_valid?(url)
#     url = URI.parse(url) rescue false
#     url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
#   end
#
#
#   # def url_valid?(value)
#   #   uri = URI.parse(value)
#   #   (uri.is_a?(URI::HTTP) ) && !uri.host.nil?
#   # rescue URI::InvalidURIError
#   #   false
#   # end
#   #
#   # def validate_each(record, attribute, value)
#   #   unless value.present? && url_valid?(value)
#   #     record.errors.add(attribute, 'is not a valid HTTP URL')
#   #   end
#   # end
#
# end