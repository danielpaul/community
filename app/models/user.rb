class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :calculate_graduation_year

  validates :first_name, :last_name, presence: true
  #validates_uniqueness_of :username

  enum user_type: [:student, :teacher, :admin]

  profanity_filter! :first_name, :username, :method => 'hollow'
  #=> all letters except the first and last will be replaced

  def calculate_graduation_year
    x = 5 - self.school_year
    current_year = Date.today.year
    self.year_of_graduation = current_year + x
  end
end
