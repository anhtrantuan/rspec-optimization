class Note < ActiveRecord::Base
  include PgSearch

  validates :title, presence: true
  validates :content, presence: true

  scope :starred_notes,   ->{ where(starred: true) }
  scope :unstarred_notes, ->{ where(starred: false) }
  scope :read_notes,      ->{ where(read: true) }
  scope :unread_notes,    ->{ where(read: false) }

  pg_search_scope :ft_search, against: %i(title content),
    using: { tsearch: { dictionary: 'english', prefix: true } }

  def self.search(query = nil)
    query.present? ? self.ft_search(query) : self.all
  end
end
