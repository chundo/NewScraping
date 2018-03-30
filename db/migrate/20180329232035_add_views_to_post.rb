class AddViewsToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :views, :integer
  end
end
