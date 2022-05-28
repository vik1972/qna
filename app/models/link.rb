class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates :name, :url, presence: true
  validates :url, http_url: true

  def gist?
    URI(url).scheme == 'https' && URI(url).host == 'gist.github.com'
  end
end
