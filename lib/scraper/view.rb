require 'erb'

class View
	attr_accessor :path

	def initialize(options={})
		@path = options[:path] || "#{File.dirname(__FILE__)}/views/"
	end

	def render(template, data={})
		file = File.read("#{@path}#{template}.html.erb")
		to_instance_variables(data)
		ERB.new(file).result(binding)
	end

	private
		def to_instance_variables(data)
			data.each do |key, value|
				instance_variable_set("@#{key}".to_sym, value)
			end
		end
end