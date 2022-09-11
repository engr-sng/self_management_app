class ChildTask < ApplicationRecord

  belongs_to :parent_task
  belongs_to :user

  has_one :project, through: :parent_task

  validates :title, presence: true, length: {minimum: 2, maximum: 32}
  validates :description, length: {maximum: 140}
  validates :start_date, presence: true
  validates :end_date, presence: true

end
