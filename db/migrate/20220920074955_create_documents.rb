class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.integer :project_id, null: false
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :description
      t.text :url, null: false
      t.timestamps
    end
  end
end
