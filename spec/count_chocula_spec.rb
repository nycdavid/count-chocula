require "bundler"
Bundler.require(:test)
require_relative "../count_chocula"

RSpec.describe CountChocula do
  let(:csv_string) do 
    [
      "Title,Album,Track #",
      "Happy Song,Songs Vol.1",
      "Happy Song 2,Songs Vol.1", 
      "Sad Song,Songs Vol.2"
    ].join("\n")
  end

  it "should provide the proper track numbering" do
    the_count = CountChocula.new(csv_string, "Album", "Track #")
    the_count.choculate

    expect(the_count.table.to_csv).to eq "Title,Album,Track #\nHappy Song,Songs Vol.1,1\nHappy Song 2,Songs Vol.1,2\nSad Song,Songs Vol.2,1\n"
  end

  context "when the tracks are out of order" do
    let(:csv_string) do 
      [
        "Title,Album,Track #",
        "Happy Song 2,Songs Vol.1", 
        "Sad Song,Songs Vol.2",
        "Happy Song,Songs Vol.1",
      ].join("\n")
    end

    it "should provide the proper track numbering" do
      the_count = CountChocula.new(csv_string, "Album", "Track #") 
      the_count.choculate

      expect(the_count.table.to_csv).to eq "Title,Album,Track #\nHappy Song 2,Songs Vol.1,1\nSad Song,Songs Vol.2,1\nHappy Song,Songs Vol.1,2\n"
    end
  end
end
