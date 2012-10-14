#!/usr/bin/env ruby

def pad(number)
  "%03s" % number
end

if ARGV.size == 0
  puts "You must supply a file path"
  exit!
end

found_lines     = []
line_count      = 1
file_path       = ARGV[0]
file_path       = File.expand_path(file_path) if file_path =~ /^~/
formatted_lines = []

File.open(file_path, 'r') do |file|
  while line = file.gets
    found_lines << "#{line_count}:#{line.gsub(/('|"|do)/,'').strip}" if line =~ /^\s+?(describe|context|scenario|it)/i
    line_count += 1
  end
end

found_lines.each do |line|
  line = "   #{line}" if line =~ /^\s+?it/
  formatted_lines << line
end

print formatted_lines.join("\n")
