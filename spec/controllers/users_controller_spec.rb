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

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "directs to index" do
      expect(get :index).to render_template("index")
    end
  end
end
