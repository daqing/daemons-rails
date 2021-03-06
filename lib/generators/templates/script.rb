#!/usr/bin/env ruby

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do
  $running = false
end

while $running do
  # Replace this with your code
  puts "This daemon is still running at #{Time.now}.\n"

  sleep 10
end
