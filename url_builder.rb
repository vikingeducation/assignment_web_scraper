class URLBuilder 

  attr_reader :new_url 

  def initialize(url, parameters = {}) 
    @new_url = build_url(url, parameters)
  end

  def build_url(url, parameters)
    string = url 

    parameters.each do |key, value|
      key = key.to_s.gsub(/\s/, "+")
      value = value.gsub(/\s/, "+")
      string += key.to_s + "=" + value + "&"
    end

    string
  end

end