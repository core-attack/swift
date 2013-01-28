#coding:utf-8

namespace :imi do

  desc "read xml file"
  task :read => :environment do
    Dir.glob('tmp/xml/*.xml').each do |d|
      doc = Nokogiri::XML(File.open(d))
      doc.css("issue").each do |iss|
        #year
        @year = iss.css("jdateUni").map(&:text).join(' ')
        #edition
        @num = iss.css("jnumUni").map(&:text).join(' ')
      end
      count = 0
      doc.css("issue > article").each do |a|
        #title
        title = a.css("arttitle[lang=RUS]").map(&:text).join(' ')
        #filename
        filename = a.css("fpdf").map(&:text).join(' ')
        card = CatNode.new(:cat_card_id => 2, :title => filename, :text => title)
        #pages
        pages = a.css("fpageart, lpageart").map(&:text).join('-')
        #card.json['Авторы'] = a.css("author").inject("") do |authors, author| 
        #  authors = authors author.css("[lang=RUS] surname, [lang=RUS] fname").map(&:text).join(' ')
        #end
        card.json['Авторы'] = a.css("author").map do |author| 
          author.css("[lang=RUS] surname, [lang=RUS] fname").map(&:text).join(' ')
        end.join(', ')
        #code
        code = a.css("udk").map(&:text).join(' ')
        #annot
        annot = a.css("[lang=RUS] [arttype=RAR] text").map(&:text).join(' ')
        #year
        card.json["Год"] = @year      
        card.json['Коды'] = code
        card.json['Аннотация'] = annot
        card.json['Страницы'] = pages
        card.json['Номер выпуска'] = @num
        p card.save
        p card
        p card.errors  if card.errors.any?
        count = count + 1
      end
      
      edition = CatNode.new(:cat_card_id => 1, :title => @year.to_s + " " + @num.to_s, :text => '')
      edition.json['Номер выпуска'] = @num
      edition.json['Год'] = @year
      edition.json['Статей в выпуске'] = count
      p edition.save
      p edition
      p edition.errors  if edition.errors.any?
    end
  end
end
