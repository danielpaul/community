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
  enum article_type: { article: 0, document: 1, link: 2, quizlet: 3, youtube: 4, vimeo: 5 }

  #------- PLUGINS -------#
  extend FriendlyId
  friendly_id :title, use: :slugged

  #------- VALIDATIONS -------#
  validates :status, inclusion: { in: statuses.keys }
  validates :visibility, inclusion: { in: visibilities.keys }
  validates :article_type, inclusion: { in: article_types.keys }

  validates :attachments, presence: true, if: -> { article_type == 1 }
  validates :url, presence: true, if: -> { article_type == 2 }

  validates :attachments, limit: { min: 0, max: 5 }
  validates :attachments, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates :attachments, size: { less_than: 10.megabytes , message: 'is not given between size' }
  validates :featured_image, content_type: ['image/png', 'image/jpg', 'image/jpeg']

  validates :title, :user, :category, :status, :visibility, :article_type, presence: true

  validates_length_of :title, minimum: 30, maximum: 150, allow_blank: false
  #validates :url, format: { with: URI.regexp }, if: 'url.present?'

  #------- SCOPES -------#
  scope :searchable, -> { where(visibility: :everyone).where.not(approved_by_id: nil).where('approved_at < ?', Time.now) }

  #------- METHODS -------#

  def approve!(user)
    if user.role == admin
      self.approved_by = user
      self.approved_at = Time.now
    else
      redirect_to root_path, notice: 'You cannot approve articles'
    end
  end

  def searchable?
    where(:visibility == 'everyone' && :approved_by != nil && :approved_at < Time.now)
  end

  def excerpt
  end

  def reading_length
  end

end
