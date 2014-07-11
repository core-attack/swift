@issues = CatNode.all(:cat_card_id => 1, :order => :title.asc).to_a.sort_by do |n|
  -n.json['Год'].to_f + n.json['Номер выпуска'].to_f/10
end
@count = {}
@issues.each do |e|
  y = e.json['Год']
  @count[y] ||= 0
  @count[y] += e.json['Статей в выпуске'].to_i
end
