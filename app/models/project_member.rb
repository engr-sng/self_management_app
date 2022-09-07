class ProjectMember < ApplicationRecord

  belongs_to :user
  belongs_to :project

  enum permission_status: { viewer: 0, editor: 10, administrator: 20 }

end
