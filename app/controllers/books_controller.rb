class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @new_book = Book.new
    @book_comment = BookComment.new
    # 上記をコメントを投稿するためのインスタンス変数
  end

  def index
    # @books = Book.all
    # to = Time.current.at_end_of_day
    # from = ( to - 6.day ).at_beginning_of_day
    # 下記について where~end_of_day)までを消すといいねが多い順に表示されるが付けると表示する件数が勝手に減る
    # ページネーション表示のために@booksからbooksに変えた　問題ないの？
    books = Book.includes(:favorited_users).sort {|a,b|
      b.favorited_users.includes(:favorites).where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day).size <=>
      a.favorited_users.includes(:favorites).where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day).size }
    @books = Kaminari.paginate_array(books).page(params[:page]).per(10)
    # 上記はページネーションのために追記
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
