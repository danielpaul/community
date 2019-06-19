class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable,
         :omniauthable, omniauth_providers: %i[facebook]

  attr_accessor :school_year

  before_save :calculate_graduation_year

  validates :first_name, :last_name, presence: true
  validates_uniqueness_of :username

  enum user_type: { admin: 0, teacher: 1, student: 2 }

  profanity_filter! :first_name, :last_name


  private

  def calculate_graduation_year
    return unless self.school_year

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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name || auth.info.name.split.first
      user.last_name = auth.info.last_name || auth.info.name.split.last
      # user.image = auth.info.image # assuming the user model has an image

      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.first_name = data["first_name"] if user.first_name.blank?
        user.last_name = data["last_name"] if user.last_name.blank?
      end
    end
  end
end
