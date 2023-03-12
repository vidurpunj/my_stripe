class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  # skip_before_action :verify_authenticity_token

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def new_purchase
    Stripe.api_key = 'sk_test_rTxyFQAuEqMjT0DJ0XPGzFYU'
    domain = 'https://e035-2401-4900-1c68-3bbd-fa66-f155-7297-7757.in.ngrok.io'
    @stripe_session = Stripe::Checkout::Session.create({
                                                 line_items: [{
                                                                # Provide the exact Price ID (e.g. pr_1234) of the product you want to sell
                                                                price: 'price_1MkK9WEKG9XSLvIWjQ9dqONf',
                                                                quantity: 1,
                                                              }],
                                                 mode: 'payment',
                                                 success_url: domain + book_success_path(params[:book_id]),
                                                 cancel_url: domain + book_cancel_path(params[:book_id]),
                                               })
    @book = Book.find(params[:book_id])
  end

  def create_checkout_session
    Stripe.api_key = 'sk_test_rTxyFQAuEqMjT0DJ0XPGzFYU'
    domain = 'https://46e5-2401-4900-1c68-3bbd-2260-e4a9-9d55-637a.in.ngrok.io'
    session = Stripe::Checkout::Session.create({
                                                 line_items: [{
                                                                # Provide the exact Price ID (e.g. pr_1234) of the product you want to sell
                                                                price: 'price_1MkK9WEKG9XSLvIWjQ9dqONf',
                                                                quantity: 1,
                                                              }],
                                                 mode: 'payment',
                                                 success_url: domain + '/success.html',
                                                 cancel_url: domain + '/cancel.html',
                                               })
    # redirect_to session.url, allow_other_host: true and return
    redirect_to session.url, allow_other_host: true
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :price)
    end
end
