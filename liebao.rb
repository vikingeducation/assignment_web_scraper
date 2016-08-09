require 'mechanize'

Job = Struct.new :title, :company, :salary, :place, :description

search_page = 'https://www.liepin.com/zhaopin/'

agent = Mechanize.new do |agent|
  agent.user_agent_alias = 'Windows Chrome'
  agent.history_added = Proc.new { sleep 0.5 }
end

found = []

agent.get(search_page) do |page|
  results = page.form do |search|
    search.key = 'english'
    search.dqs = '010' # City Beijing
  end.submit
  link_number = 2
  loop do
    lien = results.link_with(:text=> link_number.to_s)
    link_number += 1

    results.links_with(:href => /job.liepin.com\/(\d){3}_(\d){7}/ ).each do |link|
      current_job = Job.new
      # Go to the job describtion page
      description_page = link.click

      description_page.search("div.title-info h1").each do |node|
        current_job.title = node.text.strip
      end

      description_page.search("div.title-info h3 a").each do |node|
        current_job.company = node.text.strip
      end

      description_page.search("div.job-item p.job-item-title").each do |node|
        current_job.salary = node.text.gsub(/\s+/, "")
      end

      description_page.search("div.job-item p.basic-infor span a").each do |node|
        current_job.place = node.text.strip
      end

      description_page.search("div.job-item.main-message div.content.content-word").each do |node|
        current_job.description = node.text.strip
      end
      found << current_job
    end

    break unless lien
    results = lien.click
  end



end

found
