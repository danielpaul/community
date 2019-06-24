class Article < ApplicationRecord

  has_rich_text :content

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
  validates :attachments, content_type: [
    'image/png', 'image/jpg', 'image/jpeg',
     'application/pdf', 'application/msword',
     'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
     'application/vnd.ms-excel'
   ]

  validates :attachments, size: { less_than: 10.megabytes , message: 'is not given between size' }
  validates :featured_image, content_type: ['image/png', 'image/jpg', 'image/jpeg']

  validates :title, :user, :content, :category, :status, :visibility, :article_type, presence: true

  validates_length_of :title, minimum: 10, maximum: 150, allow_blank: false
  validates_length_of :content, minimum: 250, if: -> { article_type == 0 }
  validates :url, format: {with: URI::regexp(%w(http https))}, if: -> { url.present? }

  #------- SCOPES -------#
  scope :searchable, -> { where(visibility: :everyone).where.not(approved_by_id: nil).where('approved_at < ?', Time.now) }

  #------- CALLBACKS -------#
  before_destroy :allow_delete?

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
    self.visibility == 'everyone' && self.approved_by != nil && self.approved_at < Time.now
  end

  def excerpt
    #self.content[0,100]
    self.content.truncate(100, :separator => ' ') + " ..."
  end

  # NOT DONE YEAT
  #def reading_length
    #self.content.reading_time if article?
  #end

  #NOT DONE YET
  def quizlet_id
    regex = /(?:www\.|player\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/(?:[^\/]*)\/videos\/|album\/(?:\d+)\/video\/|video\/|)(\d+)(?:[a-zA-Z0-9_\-]+)?/i
    match = regex.match(self.url)
    if match && !match[1].blank?
      match[1]
    else
      nil
    end
  end

  def youtube_id
    regex = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
    match = regex.match(self.url)
    if match && !match[1].blank?
      match[1]
    else
      nil
    end
  end

  def vimeo_id
    regex = /(?:www\.|player\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/(?:[^\/]*)\/videos\/|album\/(?:\d+)\/video\/|video\/|)(\d+)(?:[a-zA-Z0-9_\-]+)?/i
    match = regex.match(self.url)
    if match && !match[1].blank?
      match[1]
    else
      nil
    end
  end

  private

  def allow_delete?
    self.approved_at == nil
  end

  def check_url?
    if self.quizlet?
      self.quizlet_id.present?
    elsif self.article_type == 4
      self.youtube_id.present?
    elsif self.article_type == 5
      self.vimeo_id.present?
    else
      false
    end
  end

end
