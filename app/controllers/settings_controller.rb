class SettingsController < ApplicationController
	def edit
		@videos_path = videos_path
	end

	def update
		videos_path = params[:settings][:videos_path]
		if videos_path[-1] == "/"
			videos_path = videos_path[0..-2]
		end
		update_videos_path(videos_path)
		redirect_to root_path
	end
end