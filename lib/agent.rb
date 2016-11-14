

Job = Struct.new(:title, :job_link, :employer, :location, :company_id, :job_id, :posted)

class DiceAgent < Mechanize

  def search(term)
    url = "https://www.dice.com/jobs?q="
    query = term.gsub(" ", "+")
    page = get(url + query)
    job_divs = page.search(".complete-serp-result-div")
  end
end

