Pry.config.tap do |config|
  red    = -> (str) { "\e[31m#{str}\e[0m" }
  yellow = -> (str) { "\e[33m#{str}\e[0m" }
  bold   = -> (str) { "\e[1m#{str}\e[0m" }

  config.editor = lambda do |file, line|
    "emacsclient +#{line} #{file}"
  end

  config.pager = false

  config.prompt = Pry::Prompt[:simple]

  config.exception_handler = lambda do |output, exception, _|
    output.puts bold.('Traceback:')
    (exception.backtrace || []).each.with_index(1).reverse_each do |line, index|
      color = line.start_with?(ENV['HOME']) && !line.include?('rbenv') ? red : yellow
      output.puts color.("\t#{index}: from #{line}")
    end
    output.puts red.("#{exception.class} (#{exception.message})")
  end
end

lib = File.expand_path('./lib')
$LOAD_PATH.unshift lib if File.exist?(lib) && !$LOAD_PATH.include?(lib)
