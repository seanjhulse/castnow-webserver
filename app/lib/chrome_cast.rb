class ChromeCast 
  require 'rainbow'
  require 'open3'

  def initialize
    @command = []
    @playing = false
    @time = nil
    Rails.logger.debug(Rainbow("ChromeCast initialized").blue)
  end

  # play video from path
  def play(path, time=nil)
    @command = ['screen', '-S', 'cast_session', '-X', 'quit']

    pid = run(@command)
    Process.waitpid(pid)

    @command = ['screen', '-d', '-m', '-S', 'cast_session', 'castnow', '--seek', format_time(time)]
    @command.push(path)
    @playing = true

    run(@command)
    Rails.logger.debug(Rainbow("Playing the video...").orange)
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
    @command = ['screen', '-S', 'cast_session', '-X', 'stuff', 's']
    pid = run(@command)
    # set playing state to false
    @playing = false
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
    command = ['screen', '-S', 'cast_session', '-X', 'stuff', 'time']
    Open3.popen3(*command) do |stdin, stdout, stderr, wait_thr|
      read = stdout.read
      if read.chomp == "No screen session found."
        Rails.logger.debug(Rainbow("#{read}...").red)
        return
      end

      @time = DateTime.parse(read)
      Rails.logger.debug(Rainbow("Setting current time #{@time}...").orange)
    end
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