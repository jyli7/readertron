class AddUnreadCountToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :unread_count, :integer, default: 0
  end
end
