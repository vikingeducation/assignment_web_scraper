require 'csv'

Job = Struct.new(:title, :company, :link, :location, :date, :company_id, :job_id)

class Saver

  def initialize(postings, file)
    save(postings, file)
  end

  def save(postings, file)
    raise ArgumentError if file_exists?(file)
    CSV.open(file, 'a') do |csv|
      # headers
      csv << Job.members
      postings.each do |posting|
        # print attributes of each posting
        csv << [posting.title, posting.company, posting.link, posting.location, posting.date, posting.company_id, posting.job_id]
      end
    end
  end

  def file_exists?(file)
    FileTest.exists?(file)
  end

end