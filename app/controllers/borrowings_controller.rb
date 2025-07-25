# app/controllers/borrowings_controller.rb
class BorrowingsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  before_action :authenticate_user!
  before_action :set_borrowing, only: [ :show, :return ]

  def index
    borrowings = policy_scope(Borrowing).includes(:book, :user).order(returned_at: :desc, due_at: :desc)
    @active_borrowings = borrowings.active
    @returned_borrowings = borrowings.returned

    respond_to do |format|
      format.html
      format.json { render json: borrowings, include: [ :book, :user ] }
    end
  end

  def show
    render json: @borrowing
  end

  def new
    @borrowing = Borrowing.new(book_id: params[:book_id])
  end

  def create
    @borrowing = current_user.borrowings.new(
      book_id: borrowing_params[:book_id],
      borrowed_at: Time.current
    )
    authorize @borrowing

    if @borrowing.save
      respond_to do |format|
        format.html { redirect_to borrowings_path, notice: "You borrowed \"#{@borrowing.book.title}\"" }
        format.json { render json: @borrowing, status: :created }
      end
    else
      respond_to do |format|
        format.html
        format.json { render json: @borrowing.errors, status: :unprocessable_entity }
      end
    end
  end

  def return
    authorize @borrowing, :return?

    if @borrowing.return!
      respond_to do |format|
        format.html { redirect_to dashboard_borrowings_path, notice: "Book marked as returned" }
        format.json { render json: { status: "success", message: "Book returned" } }
      end
    else
      respond_to do |format|
        format.html { redirect_to dashboard_borrowings_path, alert: "Failed to mark book as returned" }
        format.json { render json: { status: "error", errors: [ "Failed to return book" ] }, status: :unprocessable_entity }
      end
    end
  end

  def dashboard
    authorize Borrowing, :dashboard?

    @due_today = Borrowing.where(due_at: Time.current.all_day).active
    @due_after_today = Borrowing.active.includes(:user, :book) - @due_today

    @stats = {
      total_books: Book.count,
      total_borrowed: Borrowing.active.count,
      overdue_books: Borrowing.overdue.includes(:user, :book),
      due_today: @due_today.count
    }
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
    authorize @borrowing
  end

  def borrowing_params
    params.require(:borrowing).permit(:book_id)
  end
end
