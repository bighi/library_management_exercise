require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  describe "scopes" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let!(:returned_borrowing) { create(:borrowing, user: user, book: book, returned_at: Time.current) }
    let!(:active_borrowing) { create(:borrowing, user: user, book: book, returned_at: nil) }

    it "returns active borrowings" do
      expect(Borrowing.active).to include(active_borrowing)
      expect(Borrowing.active).not_to include(returned_borrowing)
    end

    it "returns returned borrowings" do
      expect(Borrowing.returned).to include(returned_borrowing)
      expect(Borrowing.returned).not_to include(active_borrowing)
    end
  end

  describe "#overdue?" do
    let(:borrowing) { create(:borrowing, due_at: 1.day.ago, returned_at: nil) }

    it "returns true if borrowing is overdue" do
      expect(borrowing.overdue?).to be true
    end

    it "returns false if borrowing is not overdue" do
      borrowing.update(due_at: 1.day.from_now)
      expect(borrowing.overdue?).to be false
    end

    it "returns false if borrowing has been returned" do
      borrowing.update(returned_at: Time.current)
      expect(borrowing.overdue?).to be false
    end
  end
end
