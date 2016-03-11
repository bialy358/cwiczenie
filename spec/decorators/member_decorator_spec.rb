require 'spec_helper'

describe MemberDecorator do
  let(:user) { create :user}
  let(:board) { create :board }
  let(:member) { create :member, user_id: user.id, board_id: board.id }

  subject { MemberDecorator.new(member) }

  it 'shows email' do
    expect( subject.show_email ).to match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/)
  end
end
