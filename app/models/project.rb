class Project < ApplicationRecord

  belongs_to :user

  has_many :project_members
  has_many :milestones
  has_many :parent_tasks, through: :milestones
  has_many :child_tasks, through: :parent_tasks

end
