class RemoveVideosPathFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :videos_path, :string
  end
end
