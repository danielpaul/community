class Article < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :category, required: true

  # ---------- [ Columns ] ---------- #
  enum status: { published: 0, draft: 1 }
  enum visibility: { everyone: 0, personal: 2 }
  enum type: { article: 0, document: 1, link: 2, quizlet: 3, youtube: 4, vimeo: 5 }

  #------- PLUGINS -------#
  extend FriendlyId
  friendly_id :title, use: :slugged

  #------- VALIDATIONS -------#
  validates :title, :status, :visibility, presence: true

end
