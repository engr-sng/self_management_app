class Project < ApplicationRecord

  belongs_to :user

  has_many :project_members
  has_many :milestones
  has_many :parent_tasks, through: :milestones
  has_many :child_tasks, through: :parent_tasks

  validates :title, presence: true, length: {minimum: 2, maximum: 32}
  validates :description, length: {maximum: 140}
  validates :start_date, presence: true
  validates :end_date, presence: true

  def initial_project_member
    project_member_new = ProjectMember.new
    project_member_new.user_id = self.user_id
    project_member_new.project_id = self.id
    project_member_new.permission = 20
    project_member_new.save
  end

  def initial_project_format
    for milestone_num in 1..4 do
      milestone_new = Milestone.new
      milestone_new.project_id = self.id
      milestone_new.title = "マイルストーン#{milestone_num}"
      milestone_new.description = "マイルストーン#{milestone_num}の説明"
      milestone_new.start_date = self.start_date
      milestone_new.end_date = self.end_date
      milestone_new.display_order = milestone_num
      milestone_new.save
      for parent_task_num in 1..4 do
        parent_task_new = ParentTask.new
        parent_task_new.milestone_id = milestone_new.id
        parent_task_new.title = "親タスク#{parent_task_num}"
        parent_task_new.description = "親タスク#{parent_task_num}の説明"
        parent_task_new.start_date = milestone_new.start_date
        parent_task_new.end_date = milestone_new.end_date
        parent_task_new.display_order = parent_task_num
        parent_task_new.save
        for child_task_num in 1..3 do
          child_task_new = ChildTask.new
          child_task_new.parent_task_id = parent_task_new.id
          child_task_new.title = "子タスク#{child_task_num}"
          child_task_new.description = "子タスク#{child_task_num}の説明"
          child_task_new.start_date = parent_task_new.start_date
          child_task_new.end_date = parent_task_new.end_date
          child_task_new.display_order = child_task_num
          child_task_new.user_id = self.user_id
          child_task_new.save
        end
      end
    end
  end

end
