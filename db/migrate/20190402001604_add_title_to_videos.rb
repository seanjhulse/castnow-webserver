class AddTitleToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :title, :string
  end
end
