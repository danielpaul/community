class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category

  # ---------- [ Columns ] ---------- #
  enum status: { published: 0, draft: 1 }
  enum publicity: { public: 0, unlisted: 1, private: 2 }

  #------- PLUGINS -------#
  extend FriendlyId
  friendly_id :title, use: :slugged

  #------- VALIDATIONS -------#
  validates :title, :status, :publicity, presence: true

end
