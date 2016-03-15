require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { create :member, user_id: 1, board_id: 1 }

  it "is invalid with same user to same board" do
    member
    expect{ create(:member, user_id: 1, board_id: 1) }.to raise_error(ActiveRecord::RecordNotUnique)
  end

end
