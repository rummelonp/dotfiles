# -*- coding: utf-8 -*-

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

  lib = File.expand_path('./lib')
  $:.unshift lib if File.exists?(lib)
end
