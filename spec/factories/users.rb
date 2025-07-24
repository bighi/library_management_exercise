FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "password123" }

    trait :librarian do
      role { :librarian }
    end

    trait :member do
      role { :member }
    end
  end
end