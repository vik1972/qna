class SearchService
  SCOPES = %w[thinking_sphinx user comment question answer].freeze

  def self.call(query)
    return unless SCOPES.include?(query[:scope])

    klass = query[:scope].classify.constantize
    klass.search(ThinkingSphinx::Query.escape(query[:query]))
  end
end
