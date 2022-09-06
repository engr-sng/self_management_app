class Milestone < ApplicationRecord

  belongs_to :project

  has_many :parent_tasks
  has_many :child_tasks, through: :parent_tasks

end
