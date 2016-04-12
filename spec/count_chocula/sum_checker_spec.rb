require "bundler"
require "csv"
require "yaml"
Bundler.require(:test)
require_relative "../../count_chocula/sum_checker"

RSpec.describe CountChocula::SumChecker do
  let(:number_headers) { YAML.load_file "spec/headers/dashbox_share_headers.yml" }
  let(:headers) { YAML.load_file("spec/headers/dashbox_headers.yml").join(",") }
  let(:incorrect_data) { File.read("spec/examples/incorrect-splits-row.csv") }
  let(:correct_data) { File.read("spec/examples/correct-splits-row.csv") }
  let(:incorrect_csv_string) { [headers, incorrect_data].join("\n") }
  let(:correct_csv_string) { [headers, correct_data].join("\n") }

  describe "#check" do
    it "should leave a row unchanged for a correct sum" do
      allow(CSV).to receive(:read).
        and_return CSV.parse(correct_csv_string, CountChocula::SumChecker::CSV_OPTS)
      pn = Pathname.new("/path/to/correct/csv/string")
      checker = CountChocula::SumChecker.new(pn, number_headers, 200.0) 
      row_before_check = checker.table[0]
      checker.check

      expect(checker.table[0]).to eq row_before_check
    end

    it "should write an error field for an incorrect sum" do
      allow(CSV).to receive(:read).
        and_return CSV.parse(incorrect_csv_string, CountChocula::SumChecker::CSV_OPTS)
      pn = Pathname.new("/path/to/correct/csv/string")
      checker = CountChocula::SumChecker.new(pn, number_headers, 200.0)
      checker.check

      expect(checker.table[0][62]).to eq "ERR: Fields do not sum to the supplied figure."
    end

    it "should cast a string sum" do
      allow(CSV).to receive(:read).
        and_return CSV.parse(correct_csv_string, CountChocula::SumChecker::CSV_OPTS)
      pn = Pathname.new("/path/to/correct/csv/string")
      checker = CountChocula::SumChecker.new(pn, number_headers, "200.0")
      row_before_check = checker.table[0]
      checker.check

      expect(checker.table[0][62]).to eq nil
    end
  end

  describe "#write" do
    it "should write to the same path that was passed to it" do
      allow(CSV).to receive(:read).
        and_return CSV.parse(correct_csv_string, CountChocula::SumChecker::CSV_OPTS)
      allow(CSV).to receive(:open).
        and_return true
      pn = Pathname.new "/path/to/correct/some-name.csv"
      checker = CountChocula::SumChecker.new(pn, number_headers, 200.0)
      checker.check
      checker.write

      expect(CSV).to have_received(:open).
        with "/path/to/correct/sum-checked_some-name.csv", "wb"
    end
  end
end
