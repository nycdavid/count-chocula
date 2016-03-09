require "yaml"
require "csv"
require "pathname"
require_relative "./count_chocula/sum_checker"

HEADERS_MAP = {
  "dashbox" => YAML.load_file("spec/headers/dashbox_share_headers.yml")
}

pathname = Pathname.new(ARGV[0])
preset_name = ARGV[1]
sum = ARGV[2]

puts "Path: #{pathname.to_path}"
puts "Preset: #{preset_name}"
puts "Sum: #{sum}"

checker = CountChocula::SumChecker.new(pathname, HEADERS_MAP[preset_name], sum)
puts "Checking sums..."
checker.check
puts "Writing finished file..."
checker.write
