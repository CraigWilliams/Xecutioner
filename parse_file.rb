#!/usr/bin/env ruby

if ARGV.size == 0
  puts "You must supply a file path"
  exit!
end

file_path = ARGV[0]
if file_path =~ /^~/
  file_path = File.expand_path(file_path)
end

file = File.open(file_path, 'r')

found_lines = []
line_count = 1

while (line = file.gets)
  found_lines << "#{line.gsub(/('|"|do)/,'').strip}:#{line_count}" if line =~ /^\s+?(describe|context|scenario|it)/i
  line_count += 1
end

formatted_lines = []
found_lines.each do |line|
  if line =~ /^\s+?it/
    line = "   #{line}"
  end
  formatted_lines << line
end

print formatted_lines.join("\n")

