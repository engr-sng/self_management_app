class ParentTask < ApplicationRecord

  belongs_to :milestone

  has_many :child_tasks, dependent: :destroy

  has_one :project, through: :milestone

end
