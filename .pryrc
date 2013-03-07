# -*- coding: utf-8 -*-

if defined?(Rails)
  lib = File::join(Rails.root, 'lib')
  ActiveSupport::Dependencies.autoload_paths << lib
  Dir[lib + '/**'].each do |f|
    class_name = File.basename(f).sub(/\.rb$/, '').camelize
    ActiveSupport::Dependencies.explicitly_unloadable_constants << class_name
  end
end

Pry.config.tap do |config|
  config.editor = lambda do |file, line|
    "emacsclient -n +#{line} #{file}"
  end

  config.pager = false

  config.prompt = [
    lambda { |obj, level, _| "> " },
    lambda { |obj, level, _| "  " }
  ]

  config.exception_handler = lambda do |output, exception, _|
    output.puts "\e[31m#{exception.class}: #{exception.message}"
    output.puts "from #{exception.backtrace.first}\e[0m"
  end
end
