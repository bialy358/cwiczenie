class Board < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true
  validates :name, uniqueness: {scope: :owner_id}

end
