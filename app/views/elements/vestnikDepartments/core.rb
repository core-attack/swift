@deps = CatNode.all(:cat_card_id => 4, :order => :title, :title.not => " Without parent")
@deps_russia = CatNode.all(:cat_card_id => 4, :order => :title, :title.not => " Without parent", :conditions => ["json LIKE '%\"Тип\":\"Российская\"%'"] )
@deps_foreign = CatNode.all(:cat_card_id => 4, :order => :title, :title.not => " Without parent", :conditions => ["json LIKE '%\"Тип\":\"Зарубежная\"%'"] )
@first_chars_arr = {}
@first_chars_arr_russia = {}
@first_chars_arr_foreign = {}
@deps.each do |dep|
  unless dep.title.blank?
    if @first_chars_arr.include?(dep.title[0].upcase.to_s)
      @first_chars_arr[dep.title[0].upcase.to_s] << dep
    else
      @first_chars_arr[dep.title[0].upcase.to_s] = []
      @first_chars_arr[dep.title[0].upcase.to_s] << dep
    end
  end
end
@deps_russia.each do |dep|
  unless dep.title.blank?
    if @first_chars_arr_russia.include?(dep.title[0].upcase.to_s)
      @first_chars_arr_russia[dep.title[0].upcase.to_s] << dep
    else
      @first_chars_arr_russia[dep.title[0].upcase.to_s] = []
      @first_chars_arr_russia[dep.title[0].upcase.to_s] << dep
    end
  end
end
@deps_foreign.each do |dep|
  unless dep.title.blank?
    if @first_chars_arr_foreign.include?(dep.title[0].upcase.to_s)
      @first_chars_arr_foreign[dep.title[0].upcase.to_s] << dep
    else
      @first_chars_arr_foreign[dep.title[0].upcase.to_s] = []
      @first_chars_arr_foreign[dep.title[0].upcase.to_s] << dep
    end
  end
end