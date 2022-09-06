class ChildTask < ApplicationRecord

  belongs_to :parent_task
  belongs_to :user

  has_one :milestone, through: :parent_task
  has_one :project, through: :milestone

end
