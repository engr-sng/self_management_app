class ParentTask < ApplicationRecord

  belongs_to :project

  has_many :child_tasks, dependent: :destroy

  validates :title, presence: true, length: {minimum: 2, maximum: 32}
  validates :description, length: {maximum: 140}

  def date_comparison(day)
    if self.parent_task_start_date <= day && self.parent_task_end_date >= day
      "parent-task-color"
    else
      ""
    end
  end

  def parent_task_start_date
    if self.child_tasks.pluck(:start_date).min.nil?
      "未設定"
    else
      self.child_tasks.pluck(:start_date).min
    end
  end

  def parent_task_end_date
    if self.child_tasks.pluck(:end_date).max.nil?
      "未設定"
    else
      self.child_tasks.pluck(:end_date).max
    end
  end

  def parent_task_status
    sum_parent_task_status = self.child_tasks.sum(:status)
    count_tasks = self.child_tasks.count
    if count_tasks == 0
      "未設定"
    elsif sum_parent_task_status == 0
      "未着手"
    elsif (sum_parent_task_status/count_tasks) < 100
      "進行中"
    elsif (sum_parent_task_status/count_tasks) == 100
      "完了"
    end
  end

  def parent_task_progress
    sum_progress = self.child_tasks.sum(:progress)
    count_tasks = self.child_tasks.count
    if count_tasks == 0
      0
    elsif sum_progress == 0
      0
    else
      (sum_progress/count_tasks).floor
    end
  end

end
