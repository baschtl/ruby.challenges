#!/usr/bin/env ruby

##
# Run with: ruby run.rb <file_name>
##

File.open(ARGV[0]).each_line do |line|
  splitted_line = line.split
  word          = splitted_line.first.chars
  cipher        = splitted_line.last.chars.to_a

  result = []
  word.each_with_index do |c, index|
    result << if cipher[index] == '1'
      c.upcase
    else
      c.downcase
    end
  end

  puts result.join
end
