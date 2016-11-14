Job

class DiceJobsPageParser
  def initialize
    @job_factory =  Struct.new( :title,
                                :company,
                                :link,
                                :location,
                                :post_date,
                                :comp_id,
                                :job_id )
  end

  # input: array of job page objects
  # output: array of structs with all attributes
  def build_jobs(job_pages)
    job_pages.map do |page|
      parse_job_page(page)
    end
  end

  def parse_job_page(page)
    job = job_factory.new
    title = get_dice_title(page)
    uri = page.uri.to_s

    job.title = get_title(page)
    job.company =
    job.link =
    job.location =
    job.post_date =
    job.comp_id =
    job.job_id =
    job
  end

  def get_dice_title(page)
    page.title.split(" - ")
  end

  def get_dice_uri(page)
    page.uri
  end

  private
  attr_reader :job_factory
end
