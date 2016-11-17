class Job
  attr_accessor :page_link,
                :job_title,
                :company_name,
                :location,
                :date

  def initialize(page_link)
    @page_link = page_link
  end

end
