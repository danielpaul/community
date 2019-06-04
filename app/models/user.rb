class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validates_uniqueness_of :display_name

  enum user_type: [:student, :teacher, :admin]
  enum school_year: [:first_year, :second_year, :third_year, :ty, :fifth_year, :sixth_year]

  profanity_filter! :first_name, :display_name, :method => 'hollow'
  #=> all letters except the first and last will be replaced
end
