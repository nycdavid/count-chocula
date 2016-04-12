require "yaml"
require "csv"
require "pathname"
require_relative "./count_chocula/track_numberer"

HEADERS_MAP = {
  "dashbox" => ["CDNum", "Tracknum"]
}

pathname = Pathname.new(ARGV[0])
preset_name = ARGV[1]

puts "Path: #{pathname.to_path}"
puts "Preset: #{preset_name}"

numberer = CountChocula::TrackNumberer.new(
  path, 
  HEADERS_MAP[preset_name][0], 
  HEADERS_MAP[preset_name][1]
)
puts "Checking categories..."
numberer.choculate
puts "Writing finished file..."
