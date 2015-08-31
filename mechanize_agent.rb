require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class DiceMech < Mechanize

  def initialize
    super
    self.user_agent_alias = 'Windows Chrome'
    self.history_added = Proc.new { sleep 0.5 }
  end
  
end