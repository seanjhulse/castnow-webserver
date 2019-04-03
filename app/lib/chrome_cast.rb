class ChromeCast 
  require 'rainbow'
  require 'open3'

  def initialize
    @playing = false
	@time = nil
	@path = nil
  end

  # start video from path
  def play(path, time=nil)
	return if path == @path
    @playing = true
	@path = path

	Open3.popen2("catt cast #{path}")
	Rails.logger.debug(Rainbow("Castnow is loading #{path}...").orange)
  end
  
  def playing
	@playing
  end

  def path
	@path
  end

  def toggle
	if @playing
		Open3.popen2("catt play")
	else
		Open3.popen2("catt pause")
	end
    # toggle playing state
    @playing = !@playing

    Rails.logger.debug(Rainbow("Toggle playing state to #{@playing}").blue)
  end

  def toggle_sound
	Open3.popen2("catt volume 0")
	Rails.logger.debug(Rainbow("Toggle sound state...").blue)
  end

  # stop playing the current video
  def stop
	Open3.popen2("catt stop")

	# set playing state to false
	@playing = false
	@path = false
    Rails.logger.debug(Rainbow("Attempting to stop video...").orange)
  end

  def seek(direction)
    if(direction == 'left') 
      @command = ['screen', '-S', 'cast_session', '-X', 'stuff', "$'\e[D'"]
    else
      @command = ['screen', '-S', 'cast_session', '-X', 'stuff', "$'\e[C'"]
    end

    Rails.logger.debug(Rainbow("Skipping #{direction}...").orange)
  end

  def format_time(time)
    return "00:00:00" unless time.nil?
    return time.strftime('%H:%M:%S')
  end

  # forks a new background process to set the new time of the cast session
  # and returns that time to the user
  def time
	i, output = Open3.popen2("catt info")
	p output.gets
	return @time
  end

end