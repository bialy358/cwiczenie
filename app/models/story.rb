class Story < ActiveRecord::Base
  belongs_to :board

  ESTIMATES = [0, 1, 2, 3, 5, 8, 13, 20 ]
  enum status: { draft: 10, active: 20, done: 30 }

  validates :title, presence: true
  validates :estimate , inclusion: { in: ESTIMATES }, allow_nil: true
  validates :description, length: {maximum: 500}
end
