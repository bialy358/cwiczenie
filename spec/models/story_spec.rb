require 'rails_helper'

RSpec.describe Story, type: :model do
  let(:story) { create :story }

  it "is valid with present title and valid estimate" do
    expect(story).to be_valid
  end

  it "is invalid with  empty title and valid estimate" do
    expect( build(:story, title: nil, estimate: 1)).to_not be_valid
  end

  it "is invalid with present title and invalid estimate " do
    expect( build(:story, title: 'a', estimate: 10)).to_not be_valid
  end

  it "is invalid with present title and invalid estimate " do
    expect( build(:story, title: 'a', estimate: nil)).to_not be_valid
  end
  it "is invalid with present title and valid estimate but too long description" do
    expect( build(:story, title: 'a', estimate: 1, description: 'a'*501)).to_not be_valid
  end
end