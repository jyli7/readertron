class AddInstapaperCredentialsToUser < ActiveRecord::Migration
  def change
    add_column :users, :instapaper_username, :string
    add_column :users, :instapaper_password, :string
  end
end
