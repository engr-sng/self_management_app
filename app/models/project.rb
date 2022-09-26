class Project < ApplicationRecord

  belongs_to :user

  has_many :project_members, dependent: :destroy
  has_many :parent_tasks, dependent: :destroy
  has_many :child_tasks, through: :parent_tasks
  has_many :documents, dependent: :destroy

  validates :user_id, presence: true
  validates :title, presence: true, length: {minimum: 2, maximum: 32}
  validates :description, length: {maximum: 140}

  def select_menber_list
    self.project_members.pluck(:user_id).map {|k|[User.find(k).display_name,k]}
  end

  def select_parent_task_list
    self.parent_tasks.pluck(:id, :title).map {|k,t|[t,k]}
  end

  def project_start_date
    if self.child_tasks.pluck(:start_date).min.nil?
      "未設定"
    else
      self.child_tasks.pluck(:start_date).min
    end
  end

  def project_end_date
    if self.child_tasks.pluck(:end_date).max.nil?
      "未設定"
    else
      self.child_tasks.pluck(:end_date).max
    end
  end

  def project_status
    sum_project_status = self.child_tasks.sum(:status)
    count_tasks = self.child_tasks.count
    if count_tasks == 0
      "未設定"
    elsif sum_project_status == 0
      "未着手"
    elsif (sum_project_status/count_tasks) < 100
      "進行中"
    elsif (sum_project_status/count_tasks) == 100
      "完了"
    end
  end

  def project_progress
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

  def project_member_task_progress(user_id)
    sum_progress = self.child_tasks.where(user_id: user_id).sum(:progress)
    count_tasks = self.child_tasks.where(user_id: user_id).count
    if count_tasks == 0
      0
    elsif sum_progress == 0
      0
    else
      (sum_progress/count_tasks).floor
    end
  end

  def project_refinement(refinement)
    if refinement.nil?
      self.project_progress != 100
    elsif refinement == "all"
      self.project_progress
    elsif refinement == "complete"
      self.project_progress == 100
    elsif refinement == "remaining"
      self.project_progress != 100
    end
  end

  def have_parent_task_get_max_display_order
    if self.parent_tasks.pluck(:display_order).max.nil?
      1
    else
      self.parent_tasks.pluck(:display_order).max + 1
    end
  end

  def have_parent_task_display_number_again
    display_order_num = 0
    self.parent_tasks.order(display_order: :ASC).each do |parent_task|
      display_order_num += 1
      parent_task.update(display_order: display_order_num)
    end
  end

  def initial_project_format(start_date,end_date)
    project_member_new = ProjectMember.new(
      user_id: self.user_id,
      project_id: self.id,
      permission: 20
    )
    project_member_new.save

    for parent_task_num in 1..4 do
      parent_task_array = ["Plan(計画)","Do(実行)","Check(評価)","Act(改善)"]
      parent_task_new = ParentTask.new(
        project_id: self.id,
        title: parent_task_array[parent_task_num - 1],
        description: "",
        display_order: parent_task_num
      )
      parent_task_new.save

      for child_task_num in 1..3 do
        child_task_new = ChildTask.new(
          parent_task_id: parent_task_new.id,
          title: "#{parent_task_array[parent_task_num - 1]}の子タスク#{child_task_num}",
          description: "",
          start_date: start_date,
          end_date: end_date,
          display_order: child_task_num,
          user_id: self.user_id
        )
        child_task_new.save
      end
    end
  end

end
