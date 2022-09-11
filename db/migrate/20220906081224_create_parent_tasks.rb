class CreateParentTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :parent_tasks do |t|
      t.integer :project_id, null: false
      t.string :title, null: false
      t.text :description
      t.integer :display_order
      t.timestamps
    end
  end
end
