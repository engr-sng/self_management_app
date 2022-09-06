class ParentTask < ApplicationRecord

  belongs_to :milestone

  has_many :child_tasks

  has_one :project, through: :milestone

end
