require "csv"

class CountChocula
  attr_reader :table

  class HeaderNotPresent < StandardError; end

  def initialize(csv_string, category_column, counter_column)
    @categories = {}
    @table = CSV.parse(csv_string, headers: :first_row)
    @category_column = category_column
    @counter_column = counter_column
    check_columns
  end

  def choculate
    @table.each do |row|
      unless @categories.has_key? row[@category_column]
        @categories[row[@category_column]] = 1
      end
      set_and_increment row
    end
  end

  private

  def set_and_increment(row)
    row[@counter_column] = @categories[row[@category_column]]
    @categories[row[@category_column]] += 1
  end

  def check_columns
    unless @table.headers.include?(@category_column) || @table.headers.include?(@counter_column)
      raise HeaderNotPresent
    end
  end
end
