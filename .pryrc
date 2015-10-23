Pry.config.tap do |config|
  config.editor = lambda do |file, line|
    "emacsclient +#{line} #{file}"
  end

  config.pager = false

  config.prompt = [
    lambda { |obj, level, _| "> " },
    lambda { |obj, level, _| "  " }
  ]

  config.exception_handler = lambda do |output, exception, _|
    message = "#{exception.class}: #{exception.message}\n" <<
      (exception.backtrace || []).map { |line| "  #{line}" }.join("\n")
    output.puts "\e[31m#{message}\e[0m"
  end
end

lib = File.expand_path('./lib')
$:.unshift lib if File.exists?(lib) && !$:.include?(lib)

begin
  require 'awesome_print'
  AwesomePrint.pry!
rescue LoadError
end
