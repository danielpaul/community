require 'rails_helper'

RSpec.describe User, type: :model do

  #------- TEACHER SETUP TESTS -------#

  it "does not complete setup for teacher with nil values" do
    user = FactoryBot.create(:user, first_name: nil, last_name: nil, school_year: nil, user_type: :teacher)
    expect(user.setup_complete?).to eq(false)
  end

  it "does not complete setup for teacher with nil last_name" do
    user = FactoryBot.create(:user, last_name: nil, school_year: nil, user_type: :teacher)
    expect(user.setup_complete?).to eq(false)
  end

  it "does complete setup for teacher with nil year_of_graduation" do
    user = FactoryBot.create(:user, school_year: nil, user_type: :teacher)
    expect(user.setup_complete?).to eq(true)
  end

  it "does complete setup for teacher valid values" do
    user = FactoryBot.create(:user, user_type: :teacher)
    expect(user.setup_complete?).to eq(true)
  end

  #------- STUDENT SETUP TESTS -------#

  it "does not complete setup for student with nil values" do
    user = FactoryBot.create(:user, first_name: nil, last_name: nil, school_year: nil, user_type: :student)
    expect(user.setup_complete?).to eq(false)
  end

  it "does not complete setup for student with nil last_name" do
    user = FactoryBot.create(:user, last_name: nil, school_year: nil, user_type: :student)
    expect(user.setup_complete?).to eq(false)
  end

  it "does complete setup for student with nil year_of_graduation" do
    user = FactoryBot.create(:user, school_year: nil, user_type: :student)
    expect(user.setup_complete?).to eq(false)
  end

  it "does complete setup for student valid values" do
    user = FactoryBot.create(:user, user_type: :student)
    expect(user.setup_complete?).to eq(true)
  end

  it "is valid with a username, first name, last name, email, and password" do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  #------- YEAR OF GRADUATION TESTS -------#

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

  #------- GET SCHOOL YEAR TESTS -------#

  context "graduation year in the past" do
    it "should return 0 " do
      user = FactoryBot.create(:user, school_year: 3)
      t = Time.local(Date.today.year + 10, 1, 2, 12, 0, 0)
      Timecop.travel(t)
      expect(user.get_school_year).to eq(0)
    end
  end

  context "checking before may" do
    before(:each) do
      t = Time.local(Date.today.year, 1, 2, 12, 0, 0)
      Timecop.travel(t)
    end

    after(:each) do
      Timecop.return
    end

    context "ty is true" do
      it "should let x be 5 " do
        user = FactoryBot.create(:user, school_year: 3, ty: true)
        t = Time.local(Date.today.year + 1, 1, 2, 12, 0, 0)
        Timecop.travel(t)
        expect(user.get_school_year).to eq(4)
      end
    end

    context "ty is false" do
      it "should let x be 6" do
        user = FactoryBot.create(:user, school_year: 3, ty: false)
        t = Time.local(Date.today.year + 1, 1, 2, 12, 0, 0)
        Timecop.travel(t)
        expect(user.get_school_year).to eq(5)
      end
    end
  end

  context "checking after may" do
    before(:each) do
      t = Time.local(Date.today.year, 12, 2, 12, 0, 0)
      Timecop.travel(t)
    end

    after(:each) do
      Timecop.return
    end

    context "ty is true" do
      it "should let x be 6" do
        user = FactoryBot.create(:user, school_year: 3, ty: true)
        t = Time.local(Date.today.year + 1, 12, 2, 12, 0, 0)
        Timecop.travel(t)
        expect(user.get_school_year).to eq(4)
      end
    end
    context "ty is false" do
      it "should let x be 7" do
        user = FactoryBot.create(:user, school_year: 3, ty: false)
        t = Time.local(Date.today.year + 1, 12, 2, 12, 0, 0)
        Timecop.travel(t)
        expect(user.get_school_year).to eq(5)
      end
    end
  end

  it { is_expected.to validate_presence_of :email }
  it { should define_enum_for(:user_type).with(['admin', 'teacher', 'student']) }

end
