require "bundler"
Bundler.require(:test)
require_relative "../count_chocula"

RSpec.describe CountChocula do
  let(:csv_string) { "Title,Album,Track #\nHappy Song,Songs Vol.1\nHappy Song 2,Songs Vol.1\nSad Song,Songs Vol.2" }

  it "should provide the proper track numbering" do
    the_count = CountChocula.new(csv_string, "Album", "Track #")
    the_count.choculate

    expect(the_count.table.to_csv).to eq "Title,Album,Track #\nHappy Song,Songs Vol.1,1\nHappy Song 2,Songs Vol.1,2\nSad Song,Songs Vol.2,1\n"
  end
end
