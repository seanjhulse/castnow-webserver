class ChromeCast 
  require 'rainbow'
  require 'open3'

  def initialize
    @time = nil
    @path = nil
    @volume = 0
    @delta = 10
    @duration = 10
    @status = nil
  end

  # start video from path
  def cast(path)
    # ignore if someone requests the same film
    return if path == @path
    @path = path

    stdin, stdout, stderr, wait_thr = Open3.popen3("catt cast #{path}")
    Rails.logger.debug(Rainbow("Castnow is loading #{path}").orange)
    Process.wait(wait_thr[:pid])
    Rails.logger.debug(Rainbow("Castnow has finished loading").blue)
    stdin.close
    stdout.close
  end

  def playing
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt status")
    status = stdout.read
    stdin.close
    stdout.close
  end

  def path
    @path
  end

  def play
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt play")
    Rails.logger.debug(Rainbow("Resuming").blue)
    stdin.close
    stdout.close
  end

  def pause
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt pause")
    Rails.logger.debug(Rainbow("Pausing").blue)
    stdin.close
    stdout.close
  end

  def sound_off
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt volume 0")
    Rails.logger.debug(Rainbow("Turn sound off").blue)
    stdin.close
    stdout.close
  end

  def sound_on
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt volume #{@volume}")
    Rails.logger.debug(Rainbow("Turn sound on").blue)
    stdin.close
    stdout.close
  end

  def sound_down
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt volumedown #{@volume > 0 ? @delta : 0}")
    stdin.close
    stdout.close
  end

  def sound_up
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt volumeup #{@volume < 100 ? @delta : 0}")
    stdin.close
    stdout.close
  end

  def stop
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt stop")
    @path = nil
    Rails.logger.debug(Rainbow("Stopping the video").orange)
    stdin.close
    stdout.close
  end

  def manual_seek(direction)
    direction == "ffwd" ? ffwd : rewind
  end

  def seek(time)
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt seek #{time}")
    stdin.close
    stdout.close
  end

  def ffwd
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt ffwd #{@duration}")
    stdin.close
    stdout.close
  end

  def rewind
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt rewind #{@duration}")
    stdin.close
    stdout.close
  end

  def format_time(time)
    return "00:00:00" unless time
    return Time.at(time).utc.strftime("%H:%M:%S")
  end

  # grab time from catt
  def time
    stdin, stdout, stderr, wait_thr = Open3.popen3("catt info")
    time_in_sec = stdout.read.split(":")[-1].gsub(" ", "").chomp.to_f
    @time = format_time(time_in_sec)

    stdin.close
    stdout.close
    return @time
  end

end