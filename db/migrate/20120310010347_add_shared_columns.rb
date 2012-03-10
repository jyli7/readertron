class AddSharedColumns < ActiveRecord::Migration
  def up
    add_column :posts, :shared, :boolean, default: false
    add_column :posts, :original_post_id, :integer
    add_column :feeds, :shared, :boolean, default: false
  end

  def down
    remove_column :posts, :shared
    remove_column :posts, :original_post_id
    remove_column :feeds, :shared
  end
end
