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
      expect(scraper.search('developer').length).to_be > 0
    end
  
  end

end
