if @swift[:module_root]
  if @swift[:module_root].include? "issues" 
    if @swift[:path_pages][@swift[:path_pages].length - 1].slug == "issue" || @swift[:path_pages][@swift[:path_pages].length - 1].slug == "show"
      @swift[:path_pages].pop
      @swift[:path_ids].pop
      slug = ''
      title = ''
      @swift[:slug].split('/').each do |step|
        if @swift[:module_root].include? "/issues/archive/issue"
          year, num, snum = @swift[:slug].split('-')
          article = CatNode.first( :cat_card_id => 2, :conditions => ["json LIKE '%\"Номер выпуска\":#{num}%' AND json LIKE '%\"Год\":#{year}%' AND json LIKE '%\"Номер в выпуске\":#{snum}%'"] )
          slug += '/' + year.to_s + '-' + num.to_s
          page = Page.get(13)  #это страница архива выпусков
          @swift[:path_pages].push( Page.new( {
            :path => "/issues/archive/show" + slug,
            :parent => page,
            :title => year.to_s + ' - ' +  num.to_s + ' issue' 
            }
          ) )
          @swift[:path_ids].push 1
          slug += '-' + snum.to_s
          @swift[:path_pages].push( Page.new( {
            :path => @swift[:module_root] + slug,
            :parent => @swift[:path_pages].last,
            :title => 'pp. ' + article.json['Страницы']  
            }
         ) )
          @swift[:path_ids].push 1
        else 
          slug += '/' + step
          page = Page.get(13)
          @swift[:path_pages].push( Page.new( {
            :path => @swift[:module_root] + slug,
            :parent => page,
            :title => step
          }
          ) )
          @swift[:path_ids].push 1
        end
      end
    end
  end
end