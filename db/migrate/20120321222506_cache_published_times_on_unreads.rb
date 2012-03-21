class CachePublishedTimesOnUnreads < ActiveRecord::Migration
  def up
    add_column :unreads, :published, :datetime
    Unread.all.each do |u|
      u.update_attribute(:published, u.post.published)
    end
  end

  def down
    remove_column :unreads, :published
  end
end
