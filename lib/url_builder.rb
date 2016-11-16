class URLBuilder 

  attr_reader :url 

  def initialize(base_uri, parameters = {}) 
    @url = build_url(base_uri, parameters)
  end

  def build_url(base_uri, parameters)
    string = base_uri

    parameters.each do |key, value|
      value = value.gsub(/\s/, "+")
      string += key.to_s + "=" + value + "&"
    end

    string
  end

end