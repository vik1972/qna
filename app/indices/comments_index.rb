ThinkingSphinx::Index.define :comment, with: :active_record do
  #fields
  indexes body, sortable: true
  indexes user.email, as: :author, sortable: true

  #attributes
  has user_id, commentable_type, commentable_id, created_at, updated_at
end