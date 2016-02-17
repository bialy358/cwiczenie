class Story < ActiveRecord::Base
  belongs_to :board

  ESTIMATES = [ 1, 2, 3, 5, 8, 13, 20 ]
  enum status: [:status1, :status2]

  validates :name, presence: true
  validates :estimate , inclusion: { in: ESTIMATES }, presence: true

end
