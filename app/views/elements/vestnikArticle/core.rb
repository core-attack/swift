﻿@year, @num, @index = @swift[:slug].split('-')
@issue = CatNode.last( :cat_card_id => 1, :conditions => ["json LIKE '%\"Номер выпуска\":#{@num}%' AND json LIKE '%\"Год\":#{@year}%'"] )
@count_issues = @issue.json['Статей в выпуске']
@index = @index.to_i
@articles = CatNode.all( :cat_card_id => 2, :conditions => ["json LIKE '%\"Номер выпуска\":#{@num}%' AND json LIKE '%\"Год\":#{@year}%'"], :order => :title).published
if @index == 1
  #@before_article = @articles.length #cicle
  if @index.to_i == @articles.length
    @after_article = 1
  else
    @after_article = @index + 1
  end
elsif @index > 1 && @index < @articles.length
  @before_article = @index - 1
  @after_article = @index + 1
elsif @index.to_i == @articles.length
  @before_article = @articles.length - 1
  #@after_article = 1 #cicle
end
@orgs = []
@WORDS = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p']

