class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :name
      t.text :body
      t.string :image
      t.string :url
      t.string :sources
      t.string :video
      t.string :cover
      t.boolean :state
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
