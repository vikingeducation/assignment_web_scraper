require 'spec_helper'
require_relative '../../../scraper.rb'

describe Server do
	let(:s){Server.new}
	let(:agent){Mechanize.new}
	let(:url){'http://localhost:3000'}
	let(:start) do
		Thread.new do
			allow(s).to receive(:puts)
			s.start
		end
	end
	let(:stop) do
		s.stop
	end

	describe '#start' do
		before {start}
		after {stop}

		it 'starts the server' do
			expect(agent.get(url)).to eq(nil)
		end
	end

	describe '#stop' do
		before do
			start
			stop
		end

		it 'stops the server' do
			expect do
				agent.get(url)
			end.to_not raise_error(Net::HTTP::Persistent::Error)
		end
	end
end