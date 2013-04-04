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
      i = 0
      doc.css("issue > article").each do |a|
        #title
        title = a.css("arttitle[lang=RUS]").map(&:text).join(' ')
        titleENG = a.css("arttitle[lang=ENG]").map(&:text).join(' ')
        #filename
        filename = a.css("fpdf").map(&:text).join(' ')
        if filename.present? 
      	  card = CatNode.new(:cat_card_id => 2, :title => filename, :text => title)
        else 
        	card = CatNode.new(:cat_card_id => 2, :title => (i.to_s + " " + @year.to_s + " " + @num.to_s + " not-exist"), :text => title)
        	i += 1
        end
        card.json['Название ENG'] = titleENG
        #pages
        pages = a.css("fpageart, lpageart").map(&:text).join('-')
        arr = {}
        a.css("author").map do |author| 
          ['RUS', 'ENG'].each do |lang|
            temp = {}
            %W[surname fname auadr auemail auwork fname].each do |key|
              temp[key] = author.css("[lang=#{lang}] #{key}").map(&:text).join(' ')
            end
            arr[lang] ||= []
            arr[lang] << temp
          end
        end
        card.json['Авторы'] = arr["RUS"]
        card.json['Авторы ENG'] = arr["ENG"]
        card.json["Год"] = @year      
        card.json['Код УДК'] = a.css("udk").map(&:text).join(' ')
        card.json['Код MSC'] = a.css("anycode").map(&:text).join(' ').to_s
        #p a.css("anycode").map(&:text).join(' ')
        card.json['Аннотация'] = a.css("abstract[lang=RUS]").map(&:text).join(' ').gsub(/\$(.+?)\$/, "\n\$\$\n\\1\n\$\$\n\n")
        card.json['Аннотация ENG'] = a.css("abstract[lang=ENG]").map(&:text).join(' ').gsub(/\$(.+?)\$/, "\n\$\$\n\\1\n\$\$\n\n")
        card.json['Страницы'] = pages
        card.json['Номер выпуска'] = @num
        card.json['Ключевые слова'] = a.css("[lang=RUS] keyword").map(&:text).join(', ')
        card.json['Ключевые слова ENG'] = a.css("[lang=ENG] keyword").map(&:text).join(', ')
        list = ''
        list = a.css("biblist").map do |part|
          part.css("blistpart").map(&:text).reject{|t|t.strip.blank?}.join('<li>')
        end.join(' ')
        card.json['Список литературы'] = list.blank? ? '' : ( "<ol><li>" + list +  "</ol>" )
        issues_hashDatePublished = {
          '2002-1' => '01.02.2002',
          '2002-2' => '01.04.2002',
          '2002-3' => '01.06.2002',
          '2003-1' => '01.02.2003',
          '2003-2' => '01.08.2003',
          '2004-1' => '01.02.2004',
          '2004-2' => '01.08.2004',
          '2005-1' => '01.02.2005',
          '2005-2' => '01.05.2005',
          '2005-3' => '01.08.2005',
          '2005-4' => '01.11.2005',
          '2006-1' => '01.02.2006',
          '2006-2' => '01.04.2006',
          '2006-3' => '01.06.2006',
          '2007-1' => '01.04.2007',
          '2012-1' => '01.02.2012',
          '2012-2' => '10.09.2012'
        }
        card.json['Поступила в редакцию'] = issues_hashDatePublished[@year.to_s + '-' + @num.to_s]
        
        count = count + 1
        card.json['Номер статьи'] = count.to_s
        card.save
        #p card.json['Поступила в редакцию']
        p card.errors  if card.errors.any?
      end
      p (@year.to_s + " " + @num.to_s)
      edition = CatNode.new(:cat_card_id => 1, :title => @year.to_s + " " + @num.to_s, :text => '')
      edition.json['Номер выпуска'] = @num
      edition.json['Год'] = @year
      edition.json['Статей в выпуске'] = count
      
      issues_hashNum = {
          '2002-1' => 24,
          '2002-2' => 25,
          '2002-3' => 26,
          '2003-1' => 27,
          '2003-2' => 28,
          '2004-1' => 29,
          '2004-2' => 30,
          '2005-1' => 31,
          '2005-2' => 32,
          '2005-3' => 33,
          '2005-4' => 34,
          '2006-1' => 35,
          '2006-2' => 36,
          '2006-3' => 37,
          '2007-1' => 38,
          '2012-1' => 39,
          '2012-2' => 40
        }
        
      edition.json['Сквозной номер'] = issues_hashNum[@year.to_s + '-' + @num.to_s]
     
      edition.save
      
      p edition.errors  if edition.errors.any?
    end
  end
end
