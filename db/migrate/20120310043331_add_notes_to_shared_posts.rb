class AddNotesToSharedPosts < ActiveRecord::Migration
  def change
    add_column :posts, :note, :text
  end
end
