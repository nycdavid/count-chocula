require "csv"

module CountChocula
  class HeaderNotPresent < StandardError; end

  class TrackNumberer
    attr_reader :table

    CSV_OPTS = {
      col_sep: ",", 
      row_sep: :auto, 
      headers: :first_row
    }

    def initialize(path, category_column, counter_column)
      @pathname = path
      @categories = {}
      @table = CSV.read(@pathname.to_path, CSV_OPTS)
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

    def write
      CSV.open output_path, "wb" do |csv|
        csv << @table.headers
        @table.each { |row| csv << row }
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

    def output_path
      "#{@pathname.dirname.to_path}/track-numbered_#{@pathname.basename.to_path}"     
    end
  end
end
