FactoryBot.define do
  factory :borrowing do
    user { nil }
    book { nil }
    borrowed_at { "2025-07-23 13:48:31" }
    due_at { "2025-07-23 13:48:31" }
    returned_at { "2025-07-23 13:48:31" }
  end
end
