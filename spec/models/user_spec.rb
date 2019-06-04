require 'rails_helper'

RSpec.describe User, type: :model do

  it "is valid with a username, first name, last name, email, and password" do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  context "regesitering before may" do
    context "ty is true" do
      it "calculates graduation year" do
        user = FactoryBot.create(:user)
        expect(user.year_of_graduation).to eq(Date.today.year + 4)
      end
    end
    context "ty is false" do
      it "calculates graduation year" do
        user = FactoryBot.create(:user)
        expect(user.year_of_graduation).to eq(Date.today.year + 4)
      end
    end
  end

  context "regesitering after may" do
    context "ty is true" do
      it "calculates graduation year" do
        user = FactoryBot.create(:user)
        expect(user.year_of_graduation).to eq(Date.today.year + 4)
      end
    end
    context "ty is false" do
      it "calculates graduation year" do
        user = FactoryBot.create(:user)
        expect(user.year_of_graduation).to eq(Date.today.year + 4)
      end
    end
  end


  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }

end
