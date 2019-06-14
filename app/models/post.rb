class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category

  # ---------- [ Columns ] ---------- #
  enum status: { published: 0, draft: 1 }
  enum visibility: { open: 0, unlisted: 1, closed: 2 }

  #------- PLUGINS -------#
  extend FriendlyId
  friendly_id :title, use: :slugged

  #------- VALIDATIONS -------#
  validates :title, :status, :visibility, presence: true

end
