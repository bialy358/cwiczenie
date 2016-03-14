class MemberForm
  include ActiveModel::Model

  attr_accessor :email, :board_id

  REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/

  validates :email, presence: true, format: { with: REGEX, message: 'incorrect email'}
  validates :board_id, presence: true
  validate :user_is_not_present
  validate :new_member_is_owner
  validate :member_already_exist

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def user_is_not_present
    errors.add(:email, 'There is not such user') unless user_found?
  end

  def new_member_is_owner
    return unless user_found?
    errors.add(:email, 'You are owner of this board') if @user.id == @board.owner_id
  end

  def user_found?
    return true if @user
    @board = Board.find(board_id)
    @user = User.find_by(email: email)
  end

  def member_already_exist
    return unless user_found?
    @member = @board.members.find_by(user_id: @user.id)
    errors.add(:email, 'This user is already member of this board') if @member
  end

  def persist!
    @member_form = Member.create!(user_id: @user.id, board_id: @board.id)
  end
end