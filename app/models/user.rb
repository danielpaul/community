class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_type: [:student, :teacher, :admin]

  profanity_filter! :first_name, :display_name, :method => 'hollow'
  #=> all letters except the first and last will be replaced
end
