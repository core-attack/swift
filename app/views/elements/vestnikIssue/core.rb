﻿@year, @num = @swift[:slug].split('-')
@issue = CatNode.last( :cat_card_id => 1, :conditions => ["json LIKE '%\"Номер выпуска\":#{@num}%' AND json LIKE '%\"Год\":#{@year}%'"] )
issues = CatNode.all(:cat_card_id => 1, :order => :title.desc).to_a
@articles = CatNode.all( :cat_card_id => 2, :conditions => ["json LIKE '%\"Номер выпуска\":#{@num}%' AND json LIKE '%\"Год\":#{@year}%'"], :order => :title ).published
not_found unless @articles.any?
index = 0
issues.each_with_index do |e, i|
  if e.json['Год'] == @issue.json['Год'] && e.json['Номер выпуска'] == @issue.json['Номер выпуска'] 
    index = i
  end
end 
if index > 0 && index < issues.length - 1
  @before_issue = issues[index + 1]
  @after_issue = issues[index - 1]
elsif index == 0 
  @before_issue = issues[index + 1]
elsif index == issues.length - 1
  @after_issue = issues[index - 1]
end
