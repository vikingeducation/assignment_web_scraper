require 'rubygems'
require 'mechanize'


Agent = Mechanize.new { |agt| agt.user_agent_alias = 'Mac Firefox' }