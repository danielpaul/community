class Category < ApplicationRecord

  belongs_to :parent, class_name: 'Category', foreign_key: 'category_id'
  scope :main_categories, -> { where(parent: nil) }

  #------- PLUGINS -------#
  extend FriendlyId
  friendly_id :name, use: :slugged

  #------- VALIDATIONS -------#
  validates :name, presence: true

end
