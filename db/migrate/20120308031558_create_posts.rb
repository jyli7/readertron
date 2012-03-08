class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :feed_id
      t.text :title
      t.string :url
      t.string :author
      t.text :summary
      t.text :content
      t.datetime :published
      
      t.timestamps
    end
  end
end
