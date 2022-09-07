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
    project_member_new.permission = 3
    project_member_new.save
  end


end
