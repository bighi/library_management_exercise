FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book #{n}" }
    author { Faker::Book.author }
    genre { Faker::Book.genre }
    sequence(:isbn) { |n| "978#{n.to_s.rjust(10, '0')}" }
    total_copies { Faker::Number.between(from: 1, to: 10) }
    available_copies { total_copies }
  end
end