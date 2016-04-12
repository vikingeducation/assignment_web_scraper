require_relative 'attributes'

Job = Struct.new(:title, :company, :link, :location, :date, :company_id, :job_id)

class Searching

  def initialize
    @attribute_handler = Attributes.new
    @result = []
  end

  def parse( page )
    jobs_list = get_posts_jobs( page )
    parse_jobs_list( jobs_list )
    @result
  end


  def get_posts_jobs( page )
    queue = []
    count = 0

    # Take the last post date if there was a previous saved search ?
    if File.exist?("last_date.txt")
      last_date = File.readlines('last_date.txt','r').join("")
    end

    # Loop through all the job posts
    page.links_with( :href => /jobs\/detail/ ).each do |link|

      # Compare to the last post date saved, so don't go any further
      unless last_date.nil?
        current_date = @attribute_handler.add_date( link.click )
        if Time.parse(current_date) - Time.parse(last_date) <= 0
          puts 'We reach your previous last post'
          break
        end
      end

      break if count >= 3 # Or break when the post is 1 day old : Time.now - current_date > 86400
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
    current_job = Job.new
    @attribute_handler.add_attributes( current_job, job )
    @result << current_job
  end

end









