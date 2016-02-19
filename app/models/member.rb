class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :board

  validates :user, :board, presence: true
  validates :user, uniqueness: {scope: :board}

end
