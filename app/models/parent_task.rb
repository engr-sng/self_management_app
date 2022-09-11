class ParentTask < ApplicationRecord

  belongs_to :project

  has_many :child_tasks, dependent: :destroy

  validates :title, presence: true, length: {minimum: 2, maximum: 32}
  validates :description, length: {maximum: 140}

end
