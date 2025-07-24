class Borrowing < ApplicationRecord
  BORROW_PERIOD = 2.weeks

  belongs_to :user
  belongs_to :book

  validates :borrowed_at,
    presence: true
  validates :due_at,
    presence: true
  validate :user_cannot_borrow_same_book_twice, on: :create
  validate :book_available, on: :create

  before_validation :set_due_date, on: :create

  scope :active, -> { where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }
  scope :overdue, -> { active.where("due_at < ?", Time.current) }

  def return!
    update!(returned_at: Time.current)
    book.update!(available_copies: book.available_copies + 1)
  end

  def overdue?
    return false if returned_at.present?

    due_at < Time.current
  end

  private

  def set_due_date
    self.borrowed_at ||= Time.current
    self.due_at ||= borrowed_at + BORROW_PERIOD
  end

  def user_cannot_borrow_same_book_twice
    if user.borrowings.active.exists?(book_id: book_id)
      errors.add(:base, "You have already borrowed this book")
    end
  end

  def book_available
    if book.available_copies <= 0
      errors.add(:base, "This book is not available for borrowing")
    end
  end
end
