module JobScrapper
  class CLI
    def start
      page = JobScrapper::Crawler.new(ask).start
      result = JobScrapper::Slicer.new page
      JobScrapper::CSVSaver.new(result.results).save
      puts 'done'
    end

    private

    def ask
      puts "Welcome to Job Scrapper! Please enter a Search term"
      gets.chomp
    end
  end
end
