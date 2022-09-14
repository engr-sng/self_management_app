class ProjectMember < ApplicationRecord

  belongs_to :user
  belongs_to :project

  enum permission: { viewer: 0, editor: 10, administrator: 20 }

  validates :project_id, presence: true
  validates :user_id, presence: true

end
