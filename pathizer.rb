require "csv"

class Pathizer
  attr_reader :table

  def initialize(csv_string, pathname_column)
    @pathname_column = pathname_column
    @table = CSV.parse(csv_string, headers: :first_row)
    check_columns
  end

  def pathize
    @table.each do |row|
      row[@pathname_column] = "/#{row["CDTitle"]}/#{row["Filename"]}"
    end
  end

  private

  def check_columns
    unless @table.headers.include? @pathname_column
      raise HeaderNotPresent
    end
  end
end
