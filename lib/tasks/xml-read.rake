#coding:utf-8

namespace :vestnik do

  desc "read xml file"
  task :read => :environment do
    CatNode.all(:cat_card_id => [1, 2, 3, 4]).destroy!

    Dir.glob('public/doc/xmls/*.xml').each do |d|
      doc = Nokogiri::XML(File.open(d))
      number = doc.css("number").map(&:text).join(' ')
      dateUni = doc.css("dateUni").map(&:text).join(' ')
      pages = doc.css("pages").map(&:text).first #maybe need fix
      
      edition = CatNode.new(:cat_card_id => 1, :title => dateUni.to_s + " " + number.to_s,  :text => "")
      edition.json["Номер выпуска"] = number.to_i
      edition.json["Год"] = dateUni.to_i
      edition.json["Статей в выпуске"] =  doc.css("article").length.to_i
      edition.json["Страниц"] = pages.split('-')[1].to_i 
      edition.save
      p edition.errors  if edition.errors.any?
      p "issue " + dateUni.to_s + " " + number.to_s + " created"
      count = 0
      doc.css("article").each do |article|
        pages= article.css("pages").map(&:text).join(' ')
        #array authors
        arrAuthors = []
        arrAuthorsOrgs = []
        #set authors info
        article.css("author").each do |author|
          surname   = author.css("individInfo[lang=ENG]").css("surname").map(&:text).join(' ')
          initials  = author.css("individInfo[lang=ENG]").css("initials").map(&:text).join(' ')
          email     = author.css("individInfo[lang=ENG]").css("email").map(&:text).join(' ')
          orgName   = author.css("individInfo[lang=ENG]").css("orgName").map(&:text).join(' ')
          otherInfo = author.css("individInfo[lang=ENG]").css("otherInfo").map(&:text).join(' ')
          newAuthor = CatNode.new(:cat_card_id => 3, :title => surname + " " + initials, :text => "")
          newAuthor.json['Фамилия'] = surname
          init = ""
          io = initials.split(' ')
          if io.length > 1
            newAuthor.json['Имя'] = io[0]
            newAuthor.json['Отчество'] = io[1]
            if io[0].length > 0 && io[1].length > 0 
              init = initials.split(' ')[0][0] + "." + initials.split(' ')[1][0] + "."
            newAuthor.json['Инициалы'] = init
            end
          else
            newAuthor.json['Имя'] = initials
          end
          newAuthor.json['E-mail'] = email 
          newAuthor.json['Другое'] = otherInfo
          
          org = CatNode.all(:title => orgName)
          if org.length == 0 
            org = CatNode.new(:cat_card_id => 4, :title => orgName)
            org.json['Тип'] = "Российская"
            org.json['Страна'] = "Russia"
            org.json['Город'] = orgName.split(' ')[0]
            org.save
          end
          p "Department " + orgName + " created"
          newAuthor.json['Организации'] = []
          lastOrg = CatNode.first(:title => orgName)
          newAuthor.json['Организации'] << lastOrg.id.to_s 
          arrAuthorsOrgs << lastOrg.id.to_s 
          newAuthor.save
          p "Author " + surname + " " + initials + " created"
          p newAuthor.errors  if newAuthor.errors.any?
          arrAuthors << newAuthor.id.to_s
        end
        
        #set article info
        title = article.css("artTitle[lang=ENG]").map(&:text).join(' ')
        abstract = article.css("abstract[lang=ENG]").map(&:text).join(' ')
        text = article.css("text[lang=RUS]").map(&:text).join(' ')
        udk = article.css("udk").map(&:text).join(' ')
        msc = article.css("anycode").map(&:text).join(' ')
        keywords = article.css("keyword").map(&:text).join(', ')
        received = article.css("dateReceived").map(&:text).join(' ')
        filename = article.css("file").map(&:text).join(' ')
        references = article.css("references").map do |part|
          part.css("reference").map(&:text).reject{|t|t.strip.blank?}.join('<li>')
        end.join(' ')

        card = CatNode.new(:cat_card_id => 2, :title => filename, :text => title)
        card.json["Авторы"] = arrAuthors
        card.json["Аннотация"] = abstract
        card.json["Ключевые слова"] = keywords
        card.json["УДК"] = udk
        card.json["MSC"] = msc
        card.json["Поступила в редакцию"] = received
        card.json["Язык"] = "ENG"
        card.json["Образец цитирования"] = ""
        card.json["Номер выпуска"] = number.to_i
        card.json["Год"] = dateUni.to_i
        card.json["Страницы"] = pages
        card.json["Публикующие организации"] = arrAuthorsOrgs
        count = count + 1
        card.json['Номер в выпуске'] = count
        card.json['Список литературы'] = "<ol><li>" + references + "</ol>"
        card.json['Раздел'] = "Mathematics"
        
        card.save
        p "Article #{filename} created"
        p card.errors  if card.errors.any?
      end
    end
  end
end
