class CreateProjectMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :project_members do |t|
      t.integer :user_id, null: false
      t.integer :project_id, null: false
      t.integer :permission, null: false, default: 0
      t.timestamps
    end
  end
end
