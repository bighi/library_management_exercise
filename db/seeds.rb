# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

member = User.create email: "member@email.com", password: "test123",
  password_confirmation: "test123", role: :member
librarian = User.create email: "librarian@email.com", password: "test123",
  password_confirmation: "test123", role: :librarian

books = []

30.times do
  books < Book.create(title: Faker::Book.title, author: Faker::Book.author,
    genre: Faker::Book.genre, isbn: rand(11111111111..99999999999), total_copies: rand(2..8))
end

# Overdue borrowing
Borrowing.create book: books.sample, user: member, borrowed_at: 15.days.ago,
  due_at: 3.days.ago

# Returned borrowings
Borrowing.create book: books.sample, user: member, borrowed_at: 15.days.ago,
  due_at: 3.days.ago, returned_at: 6.days.ago
Borrowing.create book: books.sample, user: member, borrowed_at: 28.days.ago,
  due_at: 14.days.ago, returned_at: 20.days.ago
Borrowing.create book: books.sample, user: member, borrowed_at: 55.days.ago,
  due_at: 43.days.ago, returned_at: 28.days.ago

# Active borrowings
3.times do
  borrow_date = rand(2..11).days.ago

  Borrowing.create book: books.sample, user: member, borrowed_at: borrow_date,
    due_at: borrow_date + 12.days
end