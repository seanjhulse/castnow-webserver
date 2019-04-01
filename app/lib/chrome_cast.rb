class ChromeCast 
  require 'rainbow'

  def initialize
    @command = []
    @playing = false
    Rails.logger.debug(Rainbow("ChromeCast initialized").blue)
  end

  # play video from path
  def play(path, timestamp=nil)
    @command = ['screen', '-S', 'cast_session', '-X', 'quit']

    pid = run(@command)
    Process.waitpid(pid)

    @command = ['screen', '-d', '-m', '-S', 'cast_session', 'castnow', '--seek', timestamp]
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

  def timestamp(time)
    return "00:00:00" unless time
    return DateTime.parse(time).strftime('%I:%M:%S')
  end
  
  def run(command)
    p command
    pid = Process.fork do 
      exec(*command)
    end
    return pid
  end
end