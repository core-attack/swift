#throw params
=begin
# Find all Zoos in Illinois, or those with five or more tigers
 2 Zoo.all(:state => 'IL') + Zoo.all(:tiger_count.gte => 5)
 3 # in SQL => SELECT * FROM "zoos" WHERE ("state" = 'IL' OR "tiger_count" >= 5)
 4 
 5 # It also works with the union operator
 6 Zoo.all(:state => 'IL') | Zoo.all(:tiger_count.gte => 5)
 7 # in SQL => SELECT * FROM "zoos" WHERE ("state" = 'IL' OR "tiger_count" >= 5)
 8 
 9 # Intersection produces an AND query
10 Zoo.all(:state => 'IL') & Zoo.all(:tiger_count.gte => 5)
11 # in SQL => SELECT * FROM "zoos" WHERE ("state" = 'IL' AND "tiger_count" >= 5)
12 
13 # Subtraction produces a NOT query
14 Zoo.all(:state => 'IL') - Zoo.all(:tiger_count.gte => 5)
15 # in SQL => SELECT * FROM "zoos" WHERE ("state" = 'IL' AND NOT("tiger_count" >= 5))
=end
@publications = []
if params[:authors]
  authors = CatNode.all(:cat_card_id => 3, :title.like => "%#{params[:request]}%")
  authors.each do |author|
    selection = CatNode.all(:cat_card_id => 2, :conditions => ["json LIKE '%\"Авторы\":#{'%' + author.id.to_s + '%'}%'"])
    @publications = @publications.length == 0 ? selection : @publications & selection
  end
end
if params[:jobs]
  departments = CatNode.all(:cat_card_id => 4, :title.like => "%#{params[:request]}%")
  departments.each do |department|
    selection = CatNode.all(:cat_card_id => 2, :conditions => ["json LIKE '%\"Авторы\":#{'%' + department.id.to_s + '%'}%'"])
    @publications = @publications.length == 0 ? selection :  @publications & selection 
  end
end
if params[:emails]
  authors = CatNode.all(:cat_card_id => 3, :conditions => ["json LIKE '%\"E-mail\":#{'%' + params[:request] + '%'}%'"])
  authors.each do |author|
    selection = CatNode.all(:cat_card_id => 2, :conditions => ["json LIKE '%\"Авторы\":#{'%' + author.id.to_s + '%'}%'"])
    @publications = @publications.length == 0 ? selection :  @publications & selection 
  end
end
if params[:titles] 
  selection = CatNode.all(:cat_card_id => 2, :title.like => "%#{params[:request]}%")
  @publications = @publications.length == 0 ? selection :  @publications & selection  
end
if params[:abstract] 
  selection = CatNode.all(:cat_card_id => 2, :conditions => ["json LIKE '%\"Аннотация\":#{'%' + params[:request] + '%'}%'"])
  @publications = @publications.length == 0 ? selection :  @publications & selection  
end
if params[:keywords]
  selection = CatNode.all(:cat_card_id => 2, :conditions => ["json LIKE '%\"Ключевые слова\":#{'%' + params[:request] + '%'}%'"])
  @publications = @publications.length == 0 ? selection :  @publications & selection  
end
if params[:references]
  selection = CatNode.all(:cat_card_id => 2, :conditions => ["json LIKE '%\"Список литературы\":#{'%' + params[:request] + '%'}%'"])#fix references!!!
  @publications = @publications.length == 0 ? selection :  @publications & selection  
end
@before = []
@after = []
@publications.each do |p|
  @before << p.publication_yin
end
@publications = @publications.sort_by!{|p| p.publication_yin}
@publications = @publications.reverse
@publications.each do |p|
  @after << p.publication_yin
end

