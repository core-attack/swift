@issue = CatNode.last( :cat_card_id => 1, :order => :title.asc )
issue_number = @issue.json['Номер выпуска']
issue_year = @issue.json['Год']
issues = CatNode.all(:cat_card_id => 1, :order => :title.desc).to_a
@articles = CatNode.all( :cat_card_id => 2, :conditions => ["json LIKE '%\"Номер выпуска\":#{issue_number}%' AND json LIKE '%\"Год\":#{issue_year}%'"], :order => :title ).published
index = 0
issues.each_with_index do |e, i|
  if e.json['Год'] == @issue.json['Год'] && e.json['Номер выпуска'] == @issue.json['Номер выпуска'] 
    index = i
  end
end 
if index >= 0
  @before_issue = issues[index + 1]
else
  @before_issue = issues[issues.length - 1]
end
if index <= issues.length - 1
  @after_issue = issues[index - 1]
else
  @after_issue = issues[0]
end