#!/usr/bin/env ruby

if ARGV.size == 0
  puts "You must supply a file path"
  exit!
end

found_lines     = []
line_count      = 1
file_path       = ARGV[0]
file_path       = File.expand_path(file_path) if file_path = ~ /^~/
file            = File.open(file_path, 'r')
formatted_lines = []

while (line = file.gets)
  found_lines << "#{line.gsub(/('|"|do)/,'').strip}:#{line_count}" if line =~ /^\s+?(describe|context|scenario|it)/i
  line_count += 1
end

found_lines.each do |line|
  line = "   #{line}" if line =~ /^\s+?it/
  formatted_lines << line
end

print formatted_lines.join("\n")

