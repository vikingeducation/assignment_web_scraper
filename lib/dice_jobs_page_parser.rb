Job =  Struct.new( :title, :company, :link, :location,
                   :post_date, :comp_id, :job_id ) do
                      def to_a
                        [ title, company, link, location,
                          post_date, comp_id, job_id ]
                      end
                    end

class DiceJobsPageParser
  def initialize
    @job_factory = Job
  end

  # input: array of job page objects
  # output: array of structs with all attributes
  def build_jobs(job_pages)
    job_pages.map do |page|
      parse_job_page(page)
    end
  end

    # "Full Stack Developer (Ruby on Rails) - CyberCoders - Denver, CO - 11-13-2016 | Dice.com"
    # https://www.dice.com/jobs/detail/Full-Stack-Developer-%28Ruby-on-Rails%29-CyberCoders-Denver-CO-80201/cybercod/GG2-132800612?icid=sr2-1p&q=ruby&l=denver,%20co
  def parse_job_page(page)
    job = job_factory.new
    title = get_title(page)
    uri = get_uri(page)
    job.title = get_job_title(title)
    job.company = get_job_company(title)
    job.link = page.uri.to_s
    job.location = get_job_location(title)
    job.post_date = get_job_post_date(title)
    job.comp_id = get_comp_id(uri)
    job.job_id = get_job_id(uri)
    job
  end

  private
  attr_reader :job_factory

  def get_title(page)
    title = page.title[0..-12]
    title.split(" - ")
  end

  def get_uri(page)
    uri = page.uri.to_s
    index = uri.index('?')
    uri = uri[0...index]
    uri.split('/')[-2..-1]
  end

  def get_job_title(title)
    title[0..-4].join(" ")
  end

  def get_job_company(title)
    title[-3]
  end

  def get_job_location(title)
    title[-2]
  end

  def get_job_post_date(title)
    title[-1]
  end

  def get_comp_id(uri)
    uri[0]
  end

  def get_job_id(uri)
    uri[1]
  end
end
