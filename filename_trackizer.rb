require "csv"

class FilenameTrackizer
  attr_reader :table

  class HeaderNotPresent < StandardError; end

  def initialize(csv_string, filename_column)
    @table = CSV.parse(csv_string, headers: :first_row)
    @filename_column = filename_column
    check_columns
  end

  def trackize
    @table.each do |row|
      row[@filename_column] = "#{row["Tracknum"]}_#{row[@filename_column]}.wav"
    end
  end
  
  private

  def check_columns
    unless @table.headers.include?(@filename_column)
      raise HeaderNotPresent
    end
  end
end
