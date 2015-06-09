#!/usr/bin/env ruby

##
# Run with: ruby run.rb <file_name>
##

File.open(ARGV[0]).each_line do |line|
  elements       = line.split
  elements_count = elements.length
  index          = elements.delete_at(elements_count - 1).to_i

  next if index > elements_count

  puts elements[-index]
end
