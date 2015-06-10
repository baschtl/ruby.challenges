#!/usr/bin/env ruby

##
# Run with: ruby run.rb <file_name>
##

File.open(ARGV[0]).each_line do |line|
  splitted_line = line.split(',')
  string        = splitted_line.first.strip
  removal_chars = splitted_line.last.strip.chars

  removal_chars.each do |c|
    string.delete!(c)
  end

  puts string
end
