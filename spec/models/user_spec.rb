require 'rails_helper'

RSpec.describe User, type: :model do

  it "is valid with a username, first name, last name, email, and password" do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  context "regesitering before may" do
    before(:each) do
      t = Time.local(Date.today.year, 1, 2, 12, 0, 0)
      Timecop.travel(t)
    end

    after(:each) do
      Timecop.return
    end

    context "ty is true" do
      it "should let x be 6 " do
        user = FactoryBot.create(:user, school_year: 2, ty: true)
        expect(user.year_of_graduation).to eq(Date.today.year + 4)
      end
    end

    context "ty is false" do
      it "should let x be 5" do
        user = FactoryBot.create(:user, school_year: 2, ty: false)
        expect(user.year_of_graduation).to eq(Date.today.year + 3)
      end
    end

  end

  context "regesitering after may" do
    before(:each) do
      t = Time.local(Date.today.year, 12, 2, 12, 0, 0)
      Timecop.travel(t)
    end

    after(:each) do
      Timecop.return
    end

    context "ty is true" do
      it "should let x be 7" do
        user = FactoryBot.create(:user, school_year: 2, ty: true)
        expect(user.year_of_graduation).to eq(Date.today.year + 5)
      end
    end
    context "ty is false" do
      it "should let x be 6" do
        user = FactoryBot.create(:user, school_year: 2, ty: false)
        expect(user.year_of_graduation).to eq(Date.today.year + 4)
      end
    end
  end


  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }

end
