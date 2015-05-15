# -*- coding: utf-8 -*-

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

  lib = File.expand_path('./lib')
  $:.unshift lib if File.exists?(lib) && !$:.include?(lib)
end

begin
  require 'awesome_print'
rescue LoadError
else
  AwesomePrint.pry!
end
