class Loader

  def self.load( url )
    agent = Mechanize.new
    agent.history_added = Proc.new { sleep 0.5 }
    page = agent.get( url )
  end

end