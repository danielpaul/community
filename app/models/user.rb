class User < ApplicationRecord
  has_many :posts

  # ---------- [ Columns ] ---------- #
  enum user_type: { admin: 0, teacher: 1, student: 2 }
  attr_accessor :school_year


  # ---------- [ Plugins ] ---------- #
  extend FriendlyId
  friendly_id :username_candidates, use: :slugged, slug_column: :username

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable,
         :omniauthable, omniauth_providers: %i[facebook]

  profanity_filter! :first_name, :last_name, :username


  # ---------- [ Validations ] ---------- #
  validates :username, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  #validates :first_name, :last_name, :school_year, :allow_marketing, :ty, :user_type, presence: true, if: :setup_complete?
  # Validate: self.user_type value is in the valid enums defined

  # ---------- [ Callbacks ] ---------- #
  before_save :calculate_graduation_year

  # ---------- [ Methods ] ---------- #

  def setup_complete?
    if self.first_name != nil
      return true
    else
      return false
    end
  end

  def get_school_year

    years_left = self.year_of_graduationn - Date.today.year
    x = 0

  def calculate_graduation_year
    return unless self.school_year

    current_year = Date.today.year

    if Date.today.month > 5
      if years_left < 3
        x = 7
      else
        x = self.ty ? 7 : 6
      end
    else
      if years_left < 3
        x = 6
      else
        x = self.ty ? 6 : 5
      end
    end

    return x - years_left
  end


  private

  def username_candidates
    [ self.email.split("@").first, self.first_name ]
  end

  def calculate_graduation_year
    return true if school_year.blank?

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
      # user.skip_confirmation!
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
