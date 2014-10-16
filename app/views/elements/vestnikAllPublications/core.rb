@publications = []
@all_publications = CatNode.all(:cat_card_id => 2, :order => :title).published
@publications = @all_publications
@years        = []
@countries    = []
@cities       = []
@issue        = []
@parts        = []
@all_publications.each do |p|
  h = {:number => p.json['Номер выпуска'], :value => "#{p.json['Номер выпуска']}"}
  @years        << p.json['Год']     unless @years.include?(p.json['Год'])
  @issue << h                        unless @issue.include?(h) || h.blank?
  @parts        << p.json['Раздел']  unless @parts.include?(p.json['Раздел'].to_s)
end
@issue.sort_by!{|i| i[:number]}
@authors     = CatNode.all(:cat_card_id => 3, :fields => [:id, :title], :order => :title).published
@departments = CatNode.all(:cat_card_id => 4, :order => :title).published
@departments.each do |d|
  @countries << d.json['Страна']  unless @countries.include?(d.json['Страна'])
  @cities << d.json['Город']      unless @cities.include?(d.json['Город'])
end
@countries.sort_by! {|c| c}
@cities.sort_by! {|c| c}
if params['org'] != nil && params['org'] != "0"
  pubs = CatNode.all(:cat_card_id => 2,  :departments_names.like => "%#{params['org']}%", :order => :title).published
  @publications = @publications & pubs
end
if params['author'] != nil && params['author'] != '0'
  pubs = CatNode.all(:cat_card_id => 2,  :authors_names.like => "%#{params['author']}%", :order => :title).published
  @publications = @publications & pubs
end
if params['part'] != nil && params['part'] != '0'
  pubs = CatNode.all(:cat_card_id => 2,  :conditions => ["json LIKE '%\"Раздел\":\"#{params['part']}\"%'"], :order => :title).published
  @publications = @publications & pubs
end
if params['year'] != nil && params['year'] != '0'
  pubs = CatNode.all(:cat_card_id => 2,  :conditions => ["json LIKE '%\"Год\":#{params['year']}%'"], :order => :title).published
  @publications = @publications & pubs
end
if params['issue'] != nil && params['issue'] != '0'
  pubs = CatNode.all(:cat_card_id => 2,  :conditions => ["json LIKE '%\"Номер выпуска\":#{params['issue'].to_i}%'"], :order => :title).published
  @publications = @publications & pubs
end
if params['country'] != nil && params['country'] != '0'
  #pubs = CatNode.all(:cat_card_id => 2, :departments_countries.like => "#{params['country']}", :order => :title).published
  pubs = []
  pubs_all = CatNode.all(:cat_card_id => 2, :order => :title).published
  pubs_all.each do |p|
    if p.departments_countries.include? params['country'].to_s
      unless pubs.include? p
        pubs << p
      end
    end
  end
  @publications = @publications & pubs
end
if params['city'] != nil && params['city'] != '0'
  #pubs = CatNode.all(:cat_card_id => 2, :departments_cities.like => "#{params['city']}", :order => :title).published
  pubs = []
  pubs_all = CatNode.all(:cat_card_id => 2, :order => :title).published
  pubs_all.each do |p|
    if p.departments_cities.include? params['city'].to_s
      unless pubs.include? p
        pubs << p
      end
    end
  end
  @publications = @publications & pubs
end

if params['org'] == "0" && params['author'] == "0" && params['part'] == "0" && params['year'] == "0" && params['issue'] == "0" && params['country'] == "0" && params['city'] == "0"
  @publications = CatNode.all(:cat_card_id => 2, :order => [:publication_yin.desc]).published
end
#ниже будет происходить неведомая задница
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