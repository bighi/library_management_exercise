FactoryBot.define do
  factory :borrowing do
    association :user, factory: [:user, :member]
    association :book
    borrowed_at { 3.days.ago }
    due_at { 11.days.from_now }
  end
end