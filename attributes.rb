class Attributes

  def add_attributes( current_job, job )
    @job = job
    current_job.date = add_date( @job )
    current_job.title = add_title
    current_job.link = add_link
    current_job.company = add_company
    current_job.location = add_location
  end

  def add_date( job )
    post_date = job.search('#header-wrap .posted').text.strip
    date_handler( post_date )
  end

  def add_title
    @job.search('#jt').text.strip
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

  def date_handler( time )

    # Catch the Number ( Posted 4 hours ago )
    time_number = time.match(/(\d+)/)[1].to_i

    # Catch the Unit
    time_unit = time.match(/\d+\s(.*?)\sago/)[1]

    # Find the creation time of the post
    if time_unit.include?("minute")
      sec_elapsed = time_number * 60
    elsif time_unit.include?("hour")
      sec_elapsed = time_number * 3600
    elsif time_unit.include?("day")
      sec_elapsed = time_number * 86400
    end
    post_date = (Time.now - sec_elapsed).strftime("%d %b, %Y at %H:%M")
  end
end