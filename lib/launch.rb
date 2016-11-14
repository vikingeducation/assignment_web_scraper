require 'rubygems'
require 'mechanize'
require 'chronic'
require 'csv'
require_relative 'agent.rb'
require_relative 'job_builder.rb'
require_relative 'job_saver.rb'


d = DiceAgent.new do |agent| 
    agent.user_agent_alias = 'Windows Chrome'
end

b = JobBuilder.new
s = JobSaver.new

d.history_added = Proc.new { sleep 0.5 }

jobs = d.search("rails")

jobs = b.build_jobs(jobs)

s.save("jobs.csv", jobs)
