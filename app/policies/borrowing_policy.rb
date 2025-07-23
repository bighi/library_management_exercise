class BorrowingPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.librarian? || record.user == user
  end

  def create?
    user.member?
  end

  def return?
    user.librarian?
  end

  class Scope < Scope
    def resolve
      if user.librarian?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
