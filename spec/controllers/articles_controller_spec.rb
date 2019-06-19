require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  include Devise::Test::ControllerHelpers
  render_views

  #------- FACTORY -------#

  let(:user) { create(:user, confirmed_at: Time.now) }
  let(:category) { create(:category) }
  let(:article) { create(:article, user: user, category: category) }
  let(:article_attributes) { attributes_for(:article, category_id: category.id) }

  #------- METHODS -------#

  def get_show
    get :show, params: { id: article }
  end

  def get_new
    get :new
  end

  def get_edit
    get :edit, params: { id: article }
  end

  def article_create
    post :create, params: { article: article_attributes }
  end

  def put_update
    put :update, params: { id: article, :article => {:title => "New name" } }
  end

  def delete_destroy
    delete :destroy, params: { id: article }
  end

  #------- TESTS -------#

  describe "GET #index" do
    it "directs to index" do
      expect(get :index).to render_template("index")
    end
  end

  describe "GET #show" do

    before(:each) do get_show end

    it "assigns the requested article to @article" do
      expect(assigns(:article)).to eq(article)
    end

    it "renders show with success" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    context "logged out user" do
      it "redirects to sign in" do
        sign_out user
        expect(get_new).to redirect_to new_user_session_path
      end
    end

    before(:each) do
      sign_in user
      get_new
    end

    it "creates a new article" do
      expect(assigns(:article)).to be_a_new(Article)
    end

    it "renders new with success" do
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "logged out user" do
      it "redirects to user sign in" do
        sign_out user
        expect(article_create).to redirect_to new_user_session_path
      end
    end

    before(:each) do
      sign_in user
    end

    context "with valid attributes" do
      it "creates a new article" do
        expect {
          article_create
        }.to change(Article, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not create an article" do
        expect {
          post :create, params: { article: attributes_for(:article, title: nil) }
        }.to change(Article, :count).by(0)
      end
    end
  end

  describe "GET #edit" do
    context "logged out user" do
      it "redirects to user sign in" do
        expect(get_edit).to redirect_to new_user_session_path
      end
    end

    context "logged in user" do
      before(:each) do
        sign_in user
        get_edit
      end

      it "allows edit" do
        expect(assigns(:article)).to eq(article)
      end
      it "renders edit" do
        expect(response).to render_template("edit")
      end
    end
  end


  describe "PUT #update" do
    context "logged out user" do
      it "redirects to user sign in" do
        expect(put_update).to redirect_to new_user_session_path
      end
    end

    context "logged in user" do
      before(:each) do
        sign_in user
        put :update, params: { id: article, article: attributes_for(:article, title: "test") }
      end

      it "allows update" do
        expect(Article.find(article.id).title).to eq('test')
      end
      it "redirects to article path" do
        expect(response).to redirect_to article_path(article)
      end
    end
  end

  describe "DELETE #destroy" do
    context "logged out user" do
      it "redirects to user sign in" do
        expect(delete_destroy).to redirect_to new_user_session_path
      end
    end

    context "logged in user" do
      it "deletes the article" do
        article.reload
        sign_in user
        expect {
          delete_destroy
        }.to change(Article, :count).by(-1)
      end
      it "redirects to articles path" do
        article.reload
        sign_in user
        expect(delete_destroy).to redirect_to articles_path
      end
    end
  end
end
