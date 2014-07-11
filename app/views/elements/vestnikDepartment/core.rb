@dep = CatNode.get(params[:dep_id])  
unless @dep.blank?
  @parent = ""
  if @dep
    @parent = @dep.json['Подчинение'].blank? ? "" : CatNode.get(@dep.json['Подчинение'])
  end
  @authors = []
  authors = CatNode.all(:cat_card_id => 3, :order => :title)
  authors.each do |a|
    if a.json["Организации"].include?(@dep.id.to_s)
      @authors << a
    end
  end  
  @publications_authors = []
  publications = CatNode.all(:cat_card_id => 2, :order => :title)
  publications.each do |p|
    if p.json["Публикующие организации"].include?(@dep.id.to_s)
      authors = []
      p.json['Авторы'].each do |author_id|
        authors << CatNode.get(author_id.to_i)
      end
      @publications_authors << {'publication' => p, 'authors' => authors}
    end
  end  
  @publications_authors.sort_by!{|p| p['publication'].publication_yin}
end