require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  include Devise::Test::ControllerHelpers
  render_views

  #------- FACTORY -------#

  let(:user) { create(:user) }

  #------- METHODS -------#

  def get_show
    get :show, params: { id: user }
  end

  def put_update
    put :update, params: { id: user, :user => {:first_name => "John" } }
  end

  def delete_destroy
    delete :destroy, params: { id: user }
  end

  #------- TESTS -------#

  describe "GET #index" do
    it "directs to index" do
      sign_in user
      expect(get :index).to redirect_to user_path(user.id)
    end
  end

  describe "GET #show" do
    before(:each) do
      get_show
      sign_in user
    end

    it "assigns the requested user to @user" do
      expect(assigns(:user)).to eq(user)
    end

    it "renders show with success" do
      expect(response).to render_template("show")
    end
  end

  describe "PUT #update" do
    context "logged out user" do
      it "redirects to user sign in" do
        debugger
        expect(put_update).to redirect_to new_user_session_path
      end
    end

    context "logged in user" do
      it "allows update" do
        sign_in user
        expect(User.find(user.id).first_name).to eq('John')
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
      it "deletes the user" do
        sign_in user
        expect {
          delete_destroy
        }.to change(User, :count).by(-1)
      end
    end
  end
end
