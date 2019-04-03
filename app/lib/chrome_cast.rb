class ChromeCast 
  require 'rainbow'
  require 'open3'

  def initialize
    @command = []
    @playing = false
	@time = nil
	@path = nil
    Rails.logger.debug(Rainbow("ChromeCast initialized").blue)
  end

  # start video from path
  def play(path, time=nil)
	return if path == @path

    @command = ['screen', '-S', 'cast_session', '-X', 'quit']

    pid = run(@command)
    Process.waitpid(pid)
	
    @command = ['screen', '-d', '-m', '-S', 'cast_session', 'castnow', path]
    @playing = true
	@path = path
    run(@command)
    Rails.logger.debug(Rainbow("Playing the video...").orange)
  end
  
  def playing
	@playing
  end

  def path
	@path
  end

  def toggle
    @command = ['screen', '-S', 'cast_session', '-X', 'stuff', ' ']
    pid = run(@command)

	
    # toggle playing state
    @playing = !@playing

    Rails.logger.debug(Rainbow("Toggle playing state to #{@playing}").blue)
  end

  def toggle_sound
    @command = ['screen', '-S', 'cast_session', '-X', 'stuff', 'm']
    pid = run(@command)
  end

  # stop playing the current video
  def stop
    @command = ['screen', '-S', 'cast_session', '-X', 'quit']
    pid = run(@command)

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
    pid = run(@command)

    Rails.logger.debug(Rainbow("Skipping #{direction}...").orange)
  end

  def format_time(time)
    return "00:00:00" unless time.nil?
    return time.strftime('%H:%M:%S')
  end

  # custom time function in the chrome cast that sets the time to a valid DateTime
  def set_time
    @command = ['screen', '-S', 'cast_session', '-X', 'stuff', 'v']
	pid = run(@command)
    Process.waitpid(pid)
	Rails.logger.debug(Rainbow("Setting current time #{pid}...").orange)
  end

  # forks a new background process to set the new time of the cast session
  # and returns that time to the user
  def time
    pid = Process.fork do
      set_time
    end
    Process.waitpid(pid)
    return @time
  end
  
  def run(command)
    p command
    
    pid = Process.fork do 
      exec(*command)
    end
    return pid
  end
end