require_relative '../lib/launch.rb'

d = DiceAgent.new do |agent| 
    agent.user_agent_alias = 'Windows Chrome'
end
d.history_added = Proc.new { sleep 0.5 }
db = DiceBuilder.new


i = IndeedAgent.new do |agent| 
    agent.user_agent_alias = 'Windows Chrome'
end
i.history_added = Proc.new { sleep 0.5 }
ib = IndeedBuilder.new
s = JobSaver.new


# loop do 
  dice_jobs = d.search("rails")
  dice_jobs = db.build_jobs(dice_jobs)
  indeed_jobs = i.search("rails", location: "Texas")
  indeed_jobs = ib.build_jobs(indeed_jobs)
  s.save("jobs.csv", dice_jobs)
  s.save("jobs.csv", indeed_jobs)
  puts "Saving #{indeed_jobs.length + dice_jobs.length} jobs."
#   sleep(60)
# end 
