class Job
  attr_accessor :title, :company, :link, :location, :date, :company_id, :job_id

  def initialize(title:, company:, link:, location:, date:, company_id:, job_id:)
    @title = title
    @company = company
    @link = link
    @location = location
    @date = date || Time.now
    @company_id = company_id
    @job_id = job_id
  end

  def to_a
    [title, company, link, location, date, company_id, job_id]
  end
end
