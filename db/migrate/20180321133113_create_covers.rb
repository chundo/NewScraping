class CreateCovers < ActiveRecord::Migration[5.1]
  def change
    create_table :covers do |t|
      t.string :name
      t.string :sumary
      t.string :image
      t.string :action_url
      t.boolean :status

      t.timestamps
    end
  end
end
