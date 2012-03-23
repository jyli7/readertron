class AddIndexes < ActiveRecord::Migration
  def up
    add_index :unreads, :post_id
    add_index :unreads, :user_id
    add_index :comments, :post_id
    add_index :comments, :user_id
    add_index :posts, :feed_id
    add_index :posts, :shared
    add_index :feeds, :shared
    add_index :subscriptions, :user_id
    add_index :subscriptions, :feed_id
  end

  def down
    remove_index :unreads, :post_id
    remove_index :unreads, :user_id
    remove_index :comments, :post_id
    remove_index :comments, :user_id
    remove_index :posts, :feed_id
    remove_index :posts, :shared
    remove_index :feeds, :shared
    remove_index :subscriptions, :user_id
    remove_index :subscriptions, :feed_id
  end
end
