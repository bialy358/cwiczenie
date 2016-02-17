class Board < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :stories,  foreign_key: :board_id

  validates :name, presence: true
  validates :name, uniqueness: {scope: :owner_id}

end
