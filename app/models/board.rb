class Board < ActiveRecord::Base
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :users, through: :members
  has_many :members, dependent: :destroy
  has_many :stories, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: {scope: :owner_id}
end
