require 'optparse'

# This will hold the options we parse
options = {}

OptionParser.new do |parser|
  parser.banner = "Usage: app.rb [options]"
  parser.separator ""
  parser.separator "Specific options:"
  
  parser.on("-h", "--help", "Show this help message") do
    puts parser
  end

  parser.on("-i", "--input", "Specify the input file path") do |value|
    options[:input] = value
  end

  parser.on("-o", "--output", "Specify the output file path") do |value|
    options[:output] = value
  end

  parser.on("-s", "--show", "Show stats output in console") do
    options[:show] = true
  end
end.parse!
