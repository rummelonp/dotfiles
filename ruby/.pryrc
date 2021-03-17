Pry.config.tap do |config|
  config.editor = lambda do |file, line|
    "emacsclient +#{line} #{file}"
  end

  config.pager = false

  config.prompt = Pry::Prompt[:simple]

  config.exception_handler = lambda do |output, exception, _|
    output.puts "Traceback:".bold
    (exception.backtrace || []).each.with_index(1).reverse_each do |line, index|
      color = line.start_with?(ENV['HOME']) && !line.include?('rbenv') ? :red : :yellow
      output.puts "\t#{index}: from #{line}".send(color)
    end
    output.puts "#{exception.class} (#{exception.message})".red
  end
end

lib = File.expand_path('./lib')
$LOAD_PATH.unshift lib if File.exist?(lib) && !$LOAD_PATH.include?(lib)

class String
  def red()     "\e[31m#{self}\e[0m" end
  def green()   "\e[32m#{self}\e[0m" end
  def yellow()  "\e[33m#{self}\e[0m" end
  def blue()    "\e[34m#{self}\e[0m" end
  def magenta() "\e[35m#{self}\e[0m" end
  def cyan()    "\e[36m#{self}\e[0m" end
  def bold()    "\e[1m#{self}\e[0m"  end
end
