module SearchCriteria
  FINVIZ_SCREENER_LINK_WITH_ALL_FILTERS = 'http://finviz.com/screener.ashx?v=111&ft=4'

  def get_filters
    page = @agent.get(FINVIZ_SCREENER_LINK_WITH_ALL_FILTERS)
    result = page.search('select[id^="fs_"]')
    result_2 = page.search('span[class="screener-combo-title"]')

    filter_names = []
    result_2.each do |node|
      node.css('br').each { |br| br.replace(' ') }
      filter_names << node.text
    end

    search_criteria = {}
    result.each_with_index do |node, r_index|
      filter = []
      filter_name = filter_names[r_index]
      filter_symbol = node.attribute('id').value[3..-1].to_sym
      filter << filter_name
      options = []
      node.children.each_with_index do |child, c_index|
        if c_index > 1
          selection = child.attribute('value').value
          description = child.text 
          options << [selection, description] unless description == 'Custom (Elite only)'
        end
      end
      filter << options
      search_criteria[filter_symbol] = filter
    end
    create_search_criteria_reference(search_criteria)
    search_criteria
  end

  def create_search_criteria_reference(search_criteria)
    File.open('search_criteria_reference.txt', 'w+') do |f|
      search_criteria.each do |key, value|
        f << ":#{key} (#{value[0]})\n"
        value[1].each do |option|
          f << "\t#{option[0]} (#{option[1]})\n"
        end
        f << "\n"
      end
    end
  end
end