class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: :index

  def index
    @articles = Article.all
    authorize @articles
  end

  def show
    @article = Article.friendly.find(params[:id])
  end

  # GET /articles/new
  def new
    @article = current_user.articles.new
    authorize @article
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  def create
    @article = current_user.articles.new(article_params)
    authorize @article

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  def update
      if @article.update(article_params)
        redirect_to @article, notice: 'Article was successfully updated.'
      else
        render :edit
      end
  end

  def destroy
    if @article.destroy
      redirect_to articles_url, notice: 'Article was successfully destroyed.'
    else
      render :index
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.friendly.find(params[:id])

    authorize @article
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:title, :status, :visibility, :category_id)
  end
end
