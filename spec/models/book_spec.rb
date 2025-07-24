require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:valid_attributes) {
    {
      title: "The Great Gatsby",
      author: "F. Scott Fitzgerald",
      genre: "Classic",
      isbn: "9780743273565",
      total_copies: 3
    }
  }

  it "is valid with valid attributes" do
    book = Book.new(valid_attributes)
    expect(book).to be_valid
  end

  describe "associations" do
    it { should have_many(:borrowings) }
    it { should have_many(:users).through(:borrowings) }
  end

  describe "scopes" do
    let!(:book1) { create(:book, title: "Ruby Programming", author: "Matz", genre: "Programming") }
    let!(:book2) { create(:book, title: "Rails Guide", author: "DHH", genre: "Web Development") }

    describe ".search" do
      it "returns books matching title" do
        expect(Book.search("Ruby")).to include(book1)
        expect(Book.search("Ruby")).not_to include(book2)
      end

      it "returns books matching author" do
        expect(Book.search("Matz")).to include(book1)
      end

      it "returns books matching genre" do
        expect(Book.search("Programming")).to include(book1)
      end

      it "is case insensitive" do
        expect(Book.search("ruby")).to include(book1)
      end
    end
  end

  describe "#available_copies" do
    let(:book) { create(:book, total_copies: 3) }
    let(:user) { create(:user) }

    it "decreases when a book is borrowed" do
      expect { create(:borrowing, book: book, user: user) }
        .to change { book.reload.available_copies }.by(-1)
    end

    it "increases when a book is returned" do
      borrowing = create(:borrowing, book: book, user: user)
      expect { borrowing.return! }
        .to change { book.reload.available_copies }.by(1)
    end
  end
end