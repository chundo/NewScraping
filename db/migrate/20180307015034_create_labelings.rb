class CreateLabelings < ActiveRecord::Migration[5.1]
  def change
    create_table :labelings do |t|
      t.references :tag, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
