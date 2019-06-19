require 'faker'

FactoryBot.define do
  factory :article do
    user
    category
    title { Faker::Internet.username }
  end
end
