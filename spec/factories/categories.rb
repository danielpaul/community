require 'faker'

FactoryBot.define do
  factory :category do
    name { Faker::Internet.username }
  end
end
