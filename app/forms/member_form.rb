class MemberForm
  include ActiveModel::Model

  attr_accessor :email, :board_id

  REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/

  validates :email, presence: true, format: { with: REGEX, message: 'incorrect email'}
  validates :board_id, presence: true
  validate :user_presence
  validate :user_owner?

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private
  def user_presence
    errors.add(:email, 'There is not such user') unless correct_params?
  end

  def user_owner?
    unless user_presence
      errors.add(:email, 'You are owner of this board') if @user.id == @board.owner_id
    end
  end

  def correct_params?
    return @user if defined?(@user)
    @user = User.find_by(email: email)
    @board = Board.find(board_id)
  end

  def persist!
    @member_form = Member.create!(user_id: @user.id, board_id: @board.id)
  end
end