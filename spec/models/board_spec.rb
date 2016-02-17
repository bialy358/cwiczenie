require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { create :board, owner_id: user.id }
  let(:user) { create :user}

  it "is valid with non empty name" do
    expect(board).to be_valid
  end

  it "is valid with non empty name" do
    expect( build(:board, name: nil)).to_not be_valid
  end

  it "is invalid with 2 boards same name for 1 user" do
    board
    expect( build(:board, owner_id: user.id)).to_not be_valid
  end
end
