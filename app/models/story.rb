class Story < ActiveRecord::Base
  belongs_to :board

  ESTIMATES = [ 1, 2, 3, 5, 8, 13, 20 ]
  enum status: { draft: 10, active: 20, done: 30 }

  validates :title, presence: true
  validates :estimate , inclusion: { in: ESTIMATES }, presence: true
  validates :description, length: {maximum: 500}
end
