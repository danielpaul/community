class Article < ApplicationRecord

  #------- ACTIVE STORAGE -------#
  has_one_attached :featured_image
  has_many_attached :attachments

  #------- RELATIONS -------#
  belongs_to :user, required: true
  belongs_to :category, required: true

  #------- ENUMS -------#
  enum status: { published: 0, draft: 1 }
  enum visibility: { everyone: 0, personal: 1 }
  enum type: { article: 0, document: 1, link: 2, quizlet: 3, youtube: 4, vimeo: 5 }

  #------- PLUGINS -------#
  extend FriendlyId
  friendly_id :title, use: :slugged

  #------- VALIDATIONS -------#
  validates :status, inclusion: 0..1
  validates :visibility, inclusion: 0..1
  validates :type, inclusion: 0..5

  validates :title, :status, :visibility, :type, presence: true

  #------- SCOPES -------#
  scope :searchable, -> { where(:visibility == everyone && :approved_at != nil && :approved_at < Time.now ) }

  #------- METHODS -------#

  def approve!
  end

  def searchable?
  end

  def excerpt
  end

  def reading_length
  end

end
