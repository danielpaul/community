require 'rails_helper'

RSpec.describe Article, type: :model do

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :visibility }

  it { should belong_to(:user) }
  it { should belong_to(:category) }

  it "is valid with title, status and visibility" do
    article = FactoryBot.create(:article)
    expect(article).to be_valid
  end
end
