require 'faker'

FactoryBot.define do
  factory :post do
    user
    category
    title { Faker::Internet.username }
    status { 0 }
    visibility { 0 }
  end
end
