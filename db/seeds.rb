# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create email: "member@email.com", password: "test123",
  password_confirmation: "test123", role: :member
User.create email: "librarian@email.com", password: "test123",
  password_confirmation: "test123", role: :librarian

30.times do
  Book.create title: Faker::Book.title, author: Faker::Book.author,
    genre: Faker::Book.genre, isbn: rand(11111111111..99999999999), total_copies: rand(2..8)
end