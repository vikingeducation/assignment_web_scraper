require 'web_scraper'

describe WebScraper do

  let(:scraper) {WebScraper.new}

  describe new do

    it 'sends a request to dice.com' do
      expect{scraper}.not_to raise_error

    end

  end

  describe '#search' do

    it 'searches main page form for specific job' do
      expect(scraper.search('developer').length).to be > 0
    end

    it 'allows a search location to be specified' do
      expect(scraper.search('developer', 84321).length).to be > 0
    end

  end

  # describe '#organize_results' do

  #   it 'returns a hash from the search results' do
  #     expect(scraper.search).
  #   end

  # end

end
