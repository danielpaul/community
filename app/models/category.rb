class Category < ApplicationRecord

  has_many :subjects, class_name: 'Category', foreign_key: 'category_id'
  has_many :articles

  #------- PLUGINS -------#
  extend FriendlyId
  friendly_id :name, use: :slugged

  #------- VALIDATIONS -------#
  validates :name, presence: true

end
