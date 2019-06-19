require 'rails_helper'

RSpec.describe Post, type: :model do

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :visibility }

  it { should belong_to(:user) }
  it { should belong_to(:category) }

  it "is valid with title, status and visibility" do
    post = FactoryBot.create(:post)
    expect(post).to be_valid
  end
end
