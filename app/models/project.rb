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

  enum status: { in_preparation: 0, in_progress: 10, complete: 20 }

  def select_menber_list
    self.project_members.pluck(:user_id).map {|k|[User.find(k).user_name,k]}
  end

  def initial_project_format
    project_member_new = ProjectMember.new(
      user_id: self.user_id,
      project_id: self.id,
      permission: 20
    )
    project_member_new.save

    for milestone_num in 1..4 do
      milestone_new = Milestone.new(
        project_id: self.id,
        title: "マイルストーン#{milestone_num}",
        description: "マイルストーン#{milestone_num}の説明",
        start_date: self.start_date,
        end_date: self.end_date,
        display_order: milestone_num
      )
      milestone_new.save
      for parent_task_num in 1..4 do
        parent_task_new = ParentTask.new(
          milestone_id: milestone_new.id,
          title: "親タスク#{parent_task_num}",
          description: "親タスク#{parent_task_num}の説明",
          start_date: milestone_new.start_date,
          end_date: milestone_new.end_date,
          display_order: parent_task_num
        )
        parent_task_new.save
        for child_task_num in 1..3 do
          child_task_new = ChildTask.new(
            parent_task_id: parent_task_new.id,
            title: "子タスク#{child_task_num}",
            description: "子タスク#{child_task_num}の説明",
            start_date: parent_task_new.start_date,
            end_date: parent_task_new.end_date,
            display_order: child_task_num,
            user_id: self.user_id
          )
          child_task_new.save
        end
      end
    end
  end

end
