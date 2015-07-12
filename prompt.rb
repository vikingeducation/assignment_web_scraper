class Prompt

  def get_location


  end


  def get_search_params


  puts "Enter your seach params"
  params = gets.chomp.gsub(" ", "+")


  puts "Enter your location"
  location = gets.chomp.gsub(" ", "+")
  location.gsub!(",","%2C")


  return "https://www.dice.com/jobs/q-#{params}-jtype-Full+Time-l-#{location}-radius-20-startPage-1-limit-120-jobs.html"

  end





end