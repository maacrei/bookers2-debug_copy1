class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
    # 上記３行は投稿の閲覧数を表示させるために
    @user = @book.user
    @new_book = Book.new
    @book_comment = BookComment.new
    # 上記はコメントを投稿するためのインスタンス変数

  end

  def index
    @books = Book.all.order(params[:sort])
    @book = Book.new
    # 下記は課題7aのための記述
    # 課題8dのためにコメントアウトした
    # to  = Time.current.at_beginning_of_day
    # from  = (to - 6.day).at_end_of_day
    # @books = Book.all.sort {|a,b|
      # b.favorited_users.size <=>
      # a.favorited_users.includes(:favorites).where(created_at: from...to).size }
    # @book = Book.new
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


  def search_book
    @book=Book.new
    @books = Book.search(params[:keyword])
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
    params.require(:book).permit(:title, :body, :star, :tag)
  end

end
