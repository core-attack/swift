@authors = CatNode.all(:cat_card_id => 3, :order => :title) 
@first_chars_arr = {}
@authors.each do |author|
  unless author.title.blank?
    if @first_chars_arr.include?(author.title[0].upcase.to_s)
      @first_chars_arr[author.title[0].upcase.to_s] << author
    else
      @first_chars_arr[author.title[0].upcase.to_s] = []
      @first_chars_arr[author.title[0].upcase.to_s] << author
    end
  end
end
