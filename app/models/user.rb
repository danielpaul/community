class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_type: [:student, :teacher, :admin]

  profanity_filter! :display_name, :method => 'dictionary'
  #=> banned words will be replaced by value in config/dictionary.yml
end
