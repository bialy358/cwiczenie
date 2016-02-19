class Board < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :stories, dependent: :destroy
  has_many :members, dependent: :destroy


  validates :name, presence: true
  validates :name, uniqueness: {scope: :owner_id}

  def self.of_members(current_user)
    where(id: Member.where(user_id: current_user.id).map { |member| member.board_id})
  end
end
