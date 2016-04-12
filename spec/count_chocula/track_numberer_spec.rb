require_relative "../spec_helper"
require_relative "../../count_chocula/track_numberer"

RSpec.describe CountChocula::TrackNumberer do
  let(:csv_string) do 
    [
      "Title,Album,Track #",
      "Happy Song,Songs Vol.1",
      "Happy Song 2,Songs Vol.1", 
      "Sad Song,Songs Vol.2"
    ].join("\n")
  end
  let(:correct_data) { File.read("spec/examples/correct-splits-row.csv") }
  let(:correct_csv_string) { [headers, correct_data].join("\n") }
  let(:headers) { YAML.load_file("spec/headers/dashbox_headers.yml").join(",") }

  before :each do
    allow(CSV).to receive(:read).
      and_return CSV.parse(correct_csv_string, CountChocula::TrackNumberer::CSV_OPTS)
    allow(CSV).to receive(:open).
      and_return true
  end

  it "should provide the proper track numbering" do
    post_choculated_data = [headers, File.read("spec/examples/proper_track_numbering.csv")].join("\n")
    pn = Pathname.new "/path/to/correct/some-name.csv"
    numberer = CountChocula::TrackNumberer.new(pn, "CDNum", "Tracknum")
    numberer.choculate

    expect(numberer.table.to_csv).to eq post_choculated_data
  end

  describe "#write" do
    it "should write to the same path that was passed to it" do
      pn = Pathname.new "/path/to/correct/some-name.csv"
      numberer = CountChocula::TrackNumberer.new(pn, "CDNum", "Tracknum")
      numberer.choculate
      numberer.write

      expect(CSV).to have_received(:open).
        with "/path/to/correct/track-numbered_some-name.csv", "wb"
    end
  end
end
