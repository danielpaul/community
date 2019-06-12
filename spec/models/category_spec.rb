require 'rails_helper'

RSpec.describe Category, type: :model do

  it { is_expected.to validate_presence_of :name }

  it "is valid with a name" do
    category = FactoryBot.create(:category)
    expect(category).to be_valid
  end
end
