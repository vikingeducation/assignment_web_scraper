class Filter 
  attr_accessor :date

  def initialize(date:)
    @date = date
  end
end

# exclude jobs containing things we don't want
# filter on salary