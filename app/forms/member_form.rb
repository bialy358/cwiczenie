class MemberForm
  include ActiveModel::Model
  include Virtus

  attribute :email, String
  attribute :board_id, Integer

  attr_reader :member_form

  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/, message: 'incoorect email'}
  validates :board_id, presence: true
  validate :owner?

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private
  def owner?
    user = User.find_by(email: email)
    board = Board.find(board_id)
    unless user
      errors.add(:email, 'There is not such user')
    else
      if user.id == board.owner_id
        errors.add(:email, 'You are owner of this board')
      end
    end
  end

  def persist!
    user = User.find_by(email: email)
    @member_form = Member.create!(user_id: user.id, board_id: board_id)
  end
end