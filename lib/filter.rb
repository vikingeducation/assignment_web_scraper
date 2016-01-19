class Filter
  attr_accessor :date, :title

  def initialize(date: nil, title: nil)
    @date = Chronic.parse(date) if date
    @title = title
  end

  def filter_jobs(jobs)
    jobs = filter_by_date(jobs) if date
    jobs = filter_by_title(jobs) if title
  end

  def filter_by_date(jobs)
    jobs.select! do |job|
      job.date > date
    end
  end

  def filter_by_title(jobs)
    jobs.select do |job|
      job.title =~ /#{title}/
    end
  end
end
