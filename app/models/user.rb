class User < ApplicationRecord

  # ---------- [ Columns ] ---------- #
  enum user_type: { student: 0, teacher: 1, admin: 2 }
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
  # Validate: self.user_type value is in the valid enums defined

  # ---------- [ Callbacks ] ---------- #
  before_save :calculate_graduation_year


  # ---------- [ Methods ] ---------- #

  def setup_complete?
    false
  end

  def get_school_year
    # TODO
    return 2
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
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.username = auth.info.first_name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
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
