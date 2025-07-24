class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[show edit update destroy]

  # GET /books or /books.json
  def index
    @books = policy_scope(Book).order(:title)

    respond_to do |format|
      format.html
      format.json { render json: @books }
    end
  end

  # GET /books/1 or /books/1.json
  def show
    authorize @book

    respond_to do |format|
      format.html
      format.json { render json: @book }
    end
  end

  # GET /books/new
  def new
    @book = Book.new
    authorize @book
  end

  # GET /books/1/edit
  def edit
    authorize @book
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    authorize @book

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    authorize @book
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    authorize @book
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_book
    @book = Book.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.expect(book: [:title, :author, :genre, :isbn, :total_copies])
  end
end
