class DiceJobsUI
  def initialize
    @controller = DiceScraperController.new
    @writer = JobWriter.new
  end

  def run
    loop do
      puts "Please type in the job description and city separated by a comma and space."
      puts "Example: 'developer, denver co'"
      input = get_user_input
      exit if input == 'q'
      jobs = get_search(input)
      render_job_structs(jobs)
      puts "Would you like to save these jobs? (y/n)"
      input = get_user_input
      exit if input == 'q'
      if input.downcase == 'y'
        puts 'To what file would you like to save this?'
        @writer.save_results(filepath, jobs)
      end
    end
  end


  def get_search(input)
    input = input.split(", ")
    @controller.search(input[0], input[1])
  end

  def get_user_input
    gets
  end

  def render_job_structs(jobs)
    jobs.each do |job|
      puts job.to_a.join(' ')
    end
  end
end