class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :board_id
      t.string  :title
      t.text  :description
      t.integer :status
      t.integer :estimate
      t.timestamps null: false
    end
  end
end
