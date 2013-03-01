#coding:utf-8

namespace :imi do

  desc "read xml file"
  task :read => :environment do
    CatNode.all(:cat_card_id => [1,2]).destroy!

    Dir.glob('public/doc/issues')
    
    Dir.glob('tmp/xml/*.xml').each do |d|
      doc = Nokogiri::XML(File.open(d))
      doc.css("issue").each do |iss|
        #year
        @year = iss.css("jdateUni").map(&:text).join(' ')
        #edition
        @num = iss.css("jnumUni").map(&:text).join(' ')
      end
      #date
      @date = doc.css("date").map(&:text).join(' ')
      count = 0
      doc.css("issue > article").each do |a|
        #title
        title = a.css("arttitle[lang=RUS]").map(&:text).join(' ')
        titleENG = a.css("arttitle[lang=ENG]").map(&:text).join(' ')
        #filename
        filename = a.css("fpdf").map(&:text).join(' ')
        card = CatNode.new(:cat_card_id => 2, :title => filename, :text => title)
        card.json['Название ENG'] = titleENG
        #pages
        pages = a.css("fpageart, lpageart").map(&:text).join('-')
        arrRUS = []
        arrENG = []
        a.css("author").map do |author| 
          hashRUS = {}
          hashRUS[:surname] = author.css("[lang=RUS] surname").map(&:text).join(' ')
          hashRUS[:fname] = author.css("[lang=RUS] fname").map(&:text).join(' ')
          hashRUS[:auadr] = author.css("[lang=RUS] auadr").map(&:text).join(' ')
          hashRUS[:auemail] = author.css("[lang=RUS] auemail").map(&:text).join(' ')
          hashRUS[:auwork] = author.css("[lang=RUS] auwork").map(&:text).join(' ')
          hashRUS[:fname] = author.css("[lang=RUS] fname").map(&:text).join(' ')
          arrRUS << hashRUS
          hashENG = {}
          hashENG[:surname] = author.css("[lang=ENG] surname").map(&:text).join(' ')
          hashENG[:fname] = author.css("[lang=ENG] fname").map(&:text).join(' ')
          hashENG[:auadr] = author.css("[lang=ENG] auadr").map(&:text).join(' ')
          hashENG[:auemail] = author.css("[lang=ENG] auemail").map(&:text).join(' ')
          hashENG[:auwork] = author.css("[lang=ENG] auwork").map(&:text).join(' ')
          hashENG[:fname] = author.css("[lang=ENG] fname").map(&:text).join(' ')
          arrENG << hashENG
        end
        card.json['Авторы'] = arrRUS
        card.json['Авторы ENG'] = arrENG
        
        #code
        code = a.css("udk").map(&:text).join(' ')
        #annot
        annot = a.css("abstract[lang=RUS]").map(&:text).join(' ')
        p annot
        #year
        card.json["Год"] = @year      
        card.json['Код УДК'] = code
        card.json['Аннотация'] = annot
        card.json['Страницы'] = pages
        card.json['Номер выпуска'] = @num
        card.json['Ключевые слова'] = a.css("nokeywords").map(&:text).join(' ')
        list = ''
        list = a.css("biblist").map do |part|
          part.css("blistpart").map(&:text).reject{|t|t.strip.blank?}.join('<li>')
        end.join(' ')
        card.json['Список литературы'] = list.blank? ? '' : ( "<ol><li>" + list +  "</ol>" )
        case @year.to_s + '-' + @num.to_s
        when '2003-1'
          card.json['Поступила в редакцию'] = '01.02.2003'
        when '2003-2'
          card.json['Поступила в редакцию'] = '01.08.2003'
        when '2004-1'
          card.json['Поступила в редакцию'] = '01.02.2004'
        when '2004-2'
         card.json['Поступила в редакцию'] = '01.08.2004'
        when '2005-1'
         card.json['Поступила в редакцию'] = '01.02.2005'
        when '2005-2'
          card.json['Поступила в редакцию'] = '01.05.2005'
        when '2005-3'
          card.json['Поступила в редакцию'] = '01.08.2005'
        when '2005-4'
          card.json['Поступила в редакцию'] = '01.11.2005'
        when '2006-1'
          card.json['Поступила в редакцию'] = '01.02.2006'
        when '2006-2'
          card.json['Поступила в редакцию'] = '01.04.2006'
        when '2006-3'
          card.json['Поступила в редакцию'] = '01.06.2006'
        when '2007-1'
          card.json['Поступила в редакцию'] = '01.04.2007'
        when '2012-1'
          card.json['Поступила в редакцию'] = '01.02.2012'
        when '2012-2'
          card.json['Поступила в редакцию'] = '10.09.2012'
        end  
        
        
        count = count + 1
        card.json['Номер статьи'] = count.to_s
        p card.save
        p card
        p card.errors  if card.errors.any?
      end
      
      edition = CatNode.new(:cat_card_id => 1, :title => @year.to_s + " " + @num.to_s, :text => '')
      edition.json['Номер выпуска'] = @num
      edition.json['Год'] = @year
      edition.json['Статей в выпуске'] = count
      case @year.to_s + '-' + @num.to_s
      when '2003-1'
        edition.json['Сквозной номер'] = 27
      when '2003-2'
        edition.json['Сквозной номер'] = 28
      when '2004-1'
        edition.json['Сквозной номер'] = 29
      when '2004-2'
        edition.json['Сквозной номер'] = 30
      when '2005-1'
        edition.json['Сквозной номер'] = 31
      when '2005-2'
        edition.json['Сквозной номер'] = 32
      when '2005-3'
        edition.json['Сквозной номер'] = 33
      when '2005-4'
        edition.json['Сквозной номер'] = 34
      when '2006-1'
        edition.json['Сквозной номер'] = 35
      when '2006-2'
        edition.json['Сквозной номер'] = 36
      when '2006-3'
        edition.json['Сквозной номер'] = 37
      when '2007-1'
        edition.json['Сквозной номер'] = 38
      when '2012-1'
        edition.json['Сквозной номер'] = 39
      when '2012-2'
        edition.json['Сквозной номер'] = 40
      end  
      p edition.save
      p edition
      p edition.errors  if edition.errors.any?
    end
  end
end
