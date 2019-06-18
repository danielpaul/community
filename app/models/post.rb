class Post < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :category, required: true

  # ---------- [ Columns ] ---------- #
  enum status: { published: 0, draft: 1 }
  enum visibility: { everyone: 0, unlisted: 1, personal: 2 }

  #------- PLUGINS -------#
  extend FriendlyId
  friendly_id :title, use: :slugged

  #------- VALIDATIONS -------#
  validates :title, :status, :visibility, presence: true

end
