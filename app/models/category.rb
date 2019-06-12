class Category < ApplicationRecord

  #------- PLUGINS -------#
  extend FriendlyId
  friendly_id :name, use: :slugged

  #------- VALIDATIONS -------#
  validates :name, presence: true

end
