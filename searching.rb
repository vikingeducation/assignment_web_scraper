Job = Struct.new(:title, :company, :link, :location, :date, :company_id, :job_id)

class Searching
  attr_accessor :result, :job

  def initialize
    @result = []
    @job = nil
  end

  def parse( page )
    jobs_list = get_posts_jobs( page )
    parse_jobs_list( jobs_list )
    @result
  end


  def get_posts_jobs( page )
    queue = []
    count = 0
    page.links_with( :href => /jobs\/detail/ ).each do |link|
      break if count == 1
      queue << link.click
      count += 1
    end
    queue
  end

  def parse_jobs_list( jobs_list )
    jobs_list.each do |job|
      parse_post_job( job )
    end
  end

  def parse_post_job( job )
    @job = job
    current_job = Job.new
    add_attributes( current_job )
    @result << current_job
  end

  def add_attributes( current_job )
    current_job.date = add_date
    current_job.title = add_title
    current_job.link = add_link
    current_job.company = add_company
    current_job.location = add_location
  end

  def add_date
    post_date = @job.search('#header-wrap .posted').text.strip
  end

  def add_title
    post_title = @job.search('#jt').text.strip
  end

  def add_link
    @job.uri.to_s
  end

  def add_company
    @job.search('#header-wrap .employer a.dice-btn-link').text.strip
  end

  def add_location
    @job.search('#header-wrap .details .location').text.strip
  end

end