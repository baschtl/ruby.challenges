#!/usr/bin/env ruby

##
# Run with: ruby run.rb <file_name>
##

lines     = []
num_lines = 0

File.open(ARGV[0]).each_line { |line| lines << line }

num_lines = lines.delete_at(0).to_i

puts lines.sort { |a, b| b.length <=> a.length }.take(num_lines)
