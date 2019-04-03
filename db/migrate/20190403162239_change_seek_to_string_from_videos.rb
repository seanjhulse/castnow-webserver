class ChangeSeekToStringFromVideos < ActiveRecord::Migration[5.2]
  change_table :videos do |t|
    t.change :seek, :string
  end
end
