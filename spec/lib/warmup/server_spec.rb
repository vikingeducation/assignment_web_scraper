require 'spec_helper'
require_relative '../../../warmup.rb'

describe Server do
	let(:s){Server.new}
	let(:c){Client.new}
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
			expect(c.get.code.to_i).to eq(200)
		end
	end

	describe '#stop' do
		before do
			start
			stop
		end

		it 'stops the server' do
			expect do
				c.get
			end.to raise_error(Errno::ECONNREFUSED)
		end
	end
end