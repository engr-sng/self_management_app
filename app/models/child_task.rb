class ChildTask < ApplicationRecord

  belongs_to :parent_task
  belongs_to :user

  has_one :project, through: :parent_task

  validates :parent_task_id, presence: true
  validates :title, presence: true, length: {minimum: 2, maximum: 32}
  validates :description, length: {maximum: 140}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :user_id, presence: true

  enum status: { in_preparation: 0, in_progress: 50, waiting_review: 70, corrective_action: 80, correction_confirmation: 90, complete: 100 }

  def child_task_refinement(refinement)
    if refinement.nil?
      self.progress != 100
    elsif refinement == "all"
      self.progress
    elsif refinement == "complete"
      self.progress == 100
    elsif refinement == "remaining"
      self.progress != 100
    end
  end

  def date_comparison(day)
    if self.start_date.nil?
      ""
    elsif self.end_date.nil?
      ""
    elsif self.start_date <= day && self.end_date >= day
      "child-task-color"
    else
      ""
    end
  end

end
