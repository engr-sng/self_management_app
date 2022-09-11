class ChildTask < ApplicationRecord

  belongs_to :parent_task
  belongs_to :user

  has_one :project, through: :parent_task

  validates :title, presence: true, length: {minimum: 2, maximum: 32}
  validates :description, length: {maximum: 140}
  validates :start_date, presence: true
  validates :end_date, presence: true

  enum status: { in_preparation: 0, in_progress: 50, complete: 100 }

  def date_comparison(day)
    if self.start_date <= day && self.end_date >= day
      "child-task-color"
    else
      ""
    end
  end

end
