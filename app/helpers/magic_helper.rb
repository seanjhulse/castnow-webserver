module MagicHelper
  def readable(title)
    File.basename(title,File.extname(title)).tr('^A-Za-z0-9', ' ').truncate(35).split.map{|x| x[0].upcase + x[1..-1]}.join(' ')
  end
end
