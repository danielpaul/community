class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  attr_accessor :school_year

  before_save :calculate_graduation_year

  validates :first_name, :last_name, :username, presence: true
  validates_uniqueness_of :username

  enum user_type: { student: 0, teacher: 1, admin: 2 }

  profanity_filter! :first_name, :last_name, :username


  private

  def calculate_graduation_year
    current_year = Date.today.year
    if Date.today.month > 5
      # 7 because
      x = self.ty ? 7 : 6
    else
      # because
      x = self.ty ? 6 : 5
    end
    self.year_of_graduation = current_year + x - self.school_year
  end
end
