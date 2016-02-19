class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :board

  validates :user_id, :board_id, presence: true
  validates :user, uniqueness: {scope: :board}

end
