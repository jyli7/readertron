class RemoveUnusedSubscriptionColumns < ActiveRecord::Migration
  def up
    remove_column :subscriptions, :unread_count
  end

  def down
    add_column :subscriptions, :unread_count, :integer
  end
end
