class ProjectMember < ApplicationRecord

  belongs_to :user
  belongs_to :project

  enum permission_status: { viewer: 0, editor: 1, administrator: 2, owner: 3 }

end
