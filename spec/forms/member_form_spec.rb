require 'rails_helper'

describe MemberForm do
  describe "Validation" do
    let(:owner) { create :user }
    let(:board) { create :board, owner_id: owner.id }
    context "when there is no user with that email" do
      it "fails validations" do
        member_form = described_class.new(email: 'abc@wp.pl', board_id: board.id)
        expect(member_form).to be_invalid
      end
    end
    context "when email belongs to owner" do
      it "fails validations" do
        member_form = described_class.new(email: owner.email, board_id: board.id)
        expect(member_form).to be_invalid
      end
    end
  end

end