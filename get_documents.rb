#!/usr/bin/env ruby -wKU

date = '08282010'

source_directory = '/Users/johnmyleswhite/Statistics/Datasets/CRAN_' + date

text_data = {}

Dir.chdir(source_directory)

puts "HERE"
puts Dir.getwd()

Dir.new('.').entries.each do |path|
  puts path
  next if path.match(/([^_]+).*\.tar\.gz/).nil?
  package_name = $1
  `tar xfz #{path}`
  Dir.chdir(package_name)
  package_text = `cat man/*`
  begin
    package_words = package_text.scan(/\w+/)
  rescue
    package_words = ['Not', 'UTF8']
  end
  text_data[package_name] = package_words.join(' ')
  Dir.chdir('..')
  `rm -rf #{package_name}`
end

output_filename = '/Users/johnmyleswhite/Statistics/r_recommendation_system/documents.csv'
output_file = File.new(output_filename, 'w')

output_file.puts '"Package","Text"'

text_data.keys.each do |package|
  output_file.puts "\"#{package}\",\"#{text_data[package]}\""
end

output_file.close
