class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :description
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :status, null: false, default: 0
      t.integer :progress, null: false, default: 0
      t.timestamps
    end
  end
end
