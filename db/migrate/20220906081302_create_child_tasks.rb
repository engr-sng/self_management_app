class CreateChildTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :child_tasks do |t|
      t.integer :parent_task_id, null: false
      t.string :title, null: false
      t.text :description
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :user_id, null: false
      t.integer :status, null: false, default: 0
      t.integer :progress, null: false, default: 0
      t.integer :display_order
      t.timestamps
    end
  end
end
