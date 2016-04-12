module CountChocula
  class NotAPathname < StandardError; end

  class SumChecker 
    attr_reader :table

    CSV_OPTS = {
      col_sep: ",", 
      row_sep: :auto, 
      headers: :first_row
    }

    def initialize(pathname, number_columns, end_sum)
      @pathname = pathname
      @table = CSV.read pathname.to_path, CSV_OPTS
      @number_columns = number_columns
      @end_sum = end_sum.to_f
    end

    def check
      @table.each do |row|
        if sum(row) != @end_sum
          row << "ERR: Fields do not sum to the supplied figure."
        end
      end
    end

    def write
      CSV.open output_path, "wb" do |csv|
        csv << @table.headers
        @table.each { |row| csv << row }
      end
    end

    private

    def sum(row)
      @number_columns.map { |column| row[column].to_f }.
        inject(0) { |sum, n| sum + n }
    end

    def output_path
      "#{@pathname.dirname.to_path}/sum-checked_#{@pathname.basename.to_path}"     
    end

  end
end
