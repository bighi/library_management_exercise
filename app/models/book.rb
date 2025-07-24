class Book < ApplicationRecord
  validates :title, :author, :genre, :isbn,
    presence: true
  validates :isbn,
    uniqueness: true
  validates :total_copies,
    numericality: {greater_than_or_equal_to: 0}

  has_many :borrowings
  has_many :users, through: :borrowings

  def available_copies
    total_copies - borrowings.where(returned_at: nil).count
  end
end
