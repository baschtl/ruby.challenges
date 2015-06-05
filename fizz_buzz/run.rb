#!/usr/bin/env ruby

##
# Run with: ruby run.rb <file_name>
##

File.open(ARGV[0]).each_line do |line|

  splitted_line  = line.split
  first_divider  = splitted_line[0].to_i
  second_divider = splitted_line[1].to_i
  count_until    = splitted_line[2].to_i

  array_to_print = []

  1.upto(count_until) do |i|
    if (i % first_divider == 0) && (i % second_divider == 0)
      array_to_print << "FB"
    elsif i % first_divider == 0
      array_to_print << "F"
    elsif i % second_divider == 0
      array_to_print << "B"
    else
      array_to_print << i
    end
  end
  print array_to_print.join(' ')
  puts

end
