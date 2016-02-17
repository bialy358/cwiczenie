require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { create :board, name: 'a', owner_id: 1 }

  it "is valid with non empty name" do
    expect(board).to be_valid
  end

  it "is valid with non empty name" do
    expect( build(:board, name: nil)).to_not be_valid
  end

  it "is invalid with 2 boards same name for 1 user" do
    board
    expect( build( :board, name: 'a', owner_id: 1 )).to_not be_valid
  end
end
