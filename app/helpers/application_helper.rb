# frozen_string_literal: true

module ApplicationHelper
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_update_at = klass.maximum(:update_at).try(:utc).try(:to_s, number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_update_at}"
  end
end
