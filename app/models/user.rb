class User < ApplicationRecord

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


  # ---------- [ Validations ] ----------
  validates :email, :username, presence: true, uniqueness: true
  validates :first_name, :last_name, :user_type, presence: true, if: :setup_complete?
  validates :user_type, inclusion: {in: user_types.keys}

  # ---------- [ Callbacks ] ---------- #
  before_save :calculate_graduation_year


  # ---------- [ Relations ] ---------- #
  has_many :posts

  # ---------- [ Methods ] ---------- #

  def setup_complete?
    has_to_have_value = [self.first_name, self.last_name]
    has_to_have_value << self.year_of_graduation if self.student?
    has_to_have_value.reject{|e| e.blank? }.count == has_to_have_value.count
  end


  def get_school_year
    years_left = self.year_of_graduation - Date.today.year

    if(years_left <= 0)
      return 0
    end

    if Date.today.month > 5
      x = (years_left < 3 || self.ty) ? 7 : 6
    else
      x = (years_left < 3 || self.ty) ? 6 : 5
    end

    return x - years_left


    # years_left = self.year_of_graduation - Date.today.year
    # years_left += 1 if Date.today.month > 5
    # years_left += 1 if (years_left < 3 && self.ty)
    # (years_left <= 0) ? 0 : years_left
  end


  private

  def username_candidates
    [ self.email&.split("@")&.first, self.first_name ]
  end

  def calculate_graduation_year
    return if school_year.blank?

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
