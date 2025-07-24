class BookPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.librarian?
  end

  def update?
    user.librarian?
  end

  def destroy?
    user.librarian?
  end

  def search?
    true
  end

  def borrow?
    user.borrowings.where(book_id: record.id).active.count.zero?
  end
end
