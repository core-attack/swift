#coding:utf-8
class CatNode
  include DataMapper::Resource

  property :id,                   Serial

  property :title,                String, :required => true
  property :text,                 Text
  property :authors_names,        Text
  property :departments_names,    Text
  property :departments_countries,Object
  property :departments_cities,   Object
  property :publication_year,     Integer
  property :publication_issue,    Integer
  property :publication_number,   String
  property :publication_yin,      String
  property :publication_part,     String
  property :author_departments,   String

  sluggable! :unique_index => false
  timestamps!
  userstamps!
  loggable!
  publishable!
  bondable!
  amorphous!
  recursive!
  metable!
  datatables!( :id, :title, :cat_card,
    :format => { :cat_card => { :code => 'o.cat_card && o.cat_card.title' } }
  )

  # relations
  belongs_to :cat_card, :required => true

  # hookers
  
  before :destroy do
    if self.cat_card_id == 4
      publications = CatNode.all(:cat_card_id => 2)
      publications.each do |p|
        countries = []
        cities = []
        unless p.json.blank?
          if p.json["Публикующие организации"].include?(self.id.to_s)
            p.departments_names = ""
            p.departments_countries =  ""
            p.departments_cities =  ""
            p.publication_part = ""
            original = p.json
            p.update(:json => {})
            original["Публикующие организации"].delete(self.id.to_s)
            p.json = original
            #p.json["Authors organizations"].delete(self.id.to_s)
            #p.original_attributes[:dirty] = false
            result = p.save
          end
        end
      end
    end
  end  
  
  after :save do
    if self.cat_card_id == 4
      publications = CatNode.all(:cat_card_id => 2)
      publications.each do |p|
        countries = []
        cities = []
        unless p.json.blank?
          if p.json["Публикующие организации"].include?(self.id.to_s)
            p.json["Публикующие организации"].each do |org_id|
              unless countries.include?(self.json['Страна'])
                countries << self.json['Страна']
              end
              unless cities.include?(self.json['Город'])
                cities << self.json['Город']
              end
            end
            countries.sort!
            cities.sort!
            p.departments_countries = countries.length > 0 ? countries[0].strip : ""
            p.departments_cities = cities.length > 0 ? cities[0].strip : ""
            p.save
          end
        end
      end
    end
  end
  
  before :create do
    if self.cat_card_id == 2
      key = "Авторы"
      unless self.json[key]
        self.json[key] = []
      end
      authors = []
      if self.json.length > 0
        self.json[key].each do |author_id|
          author = CatNode.get(author_id.to_i)
          authors << author.title + ", " + author.id.to_s
        end
      end
      authors.sort!
      self.authors_names = authors.length > 0 ? authors[0].strip : ""
      p "AUTHOR NAME: " + self.authors_names

      key = "Публикующие организации"
      unless self.json[key]
        self.json[key] = []
      end
      departments = []
      countries = []
      cities = []
      if self.json.length > 0
        self.json[key].each do |department_id|
          dep = CatNode.get(department_id.to_i)
          tmp = dep.title + ", " + dep.id.to_s
          unless departments.include?(tmp)
            departments << tmp
          end
          unless countries.include?(dep.json['Страна'])
            countries << dep.json['Страна']
          end
          unless cities.include?(dep.json['Город'])
            cities << dep.json['Город']
          end
        end
      end
      departments.sort!
      countries.sort!
      cities.sort!
      
      p "Set other columns..."
      self.departments_names = departments.length > 0 ? departments[0].strip : ""
      p "DEPARTMENT NAME: " + self.departments_names
      self.departments_countries = countries.length > 0 ? countries[0].strip : ""
      p "DEPARTMENT COUNTRIES: " + self.departments_countries
      self.departments_cities = cities.length > 0 ? cities[0].strip : ""
      p "DEPARTMENT CITIES: " + self.departments_cities
      unless self.json['Год'].blank?
        self.publication_year = self.json['Год']
        p "PUBLICATION YEAR: " + self.publication_year.to_s
      end
      unless self.json['Номер выпуска'].blank?    
        self.publication_issue = self.json['Номер выпуска'] 
        p "PUBLICATION ISSUE: " + self.publication_issue.to_s
      end
      unless self.json['Номер в выпуске'].blank?
        self.publication_number = self.json['Номер в выпуске'] < 10 ? "0" + self.json['Номер в выпуске'].to_s : self.json['Номер в выпуске']
        p "PUBLICATION NUMBER: " + self.publication_number.to_s
      end
      unless self.json['Раздел'].blank?
        self.publication_part = self.json['Раздел'].to_s 
        p "PUBLICATION PART: " + self.publication_part.to_s
      end
    elsif self.cat_card_id == 4
      publications = CatNode.all(:cat_card_id => 2)
      publications.each do |p|
        countries = []
        cities = []
        unless p.json.blank?
          if p.json["Публикующие организации"].include?(self.id.to_s)
            p.json["Публикующие организации"].each do |org_id|
              unless countries.include?(self.json['Страна'])
                countries << self.json['Страна']
              end
              unless cities.include?(self.json['Город'])
                cities << self.json['Город']
              end
            end
            countries.sort!
            cities.sort!
            p.departments_countries = countries.length > 0 ? countries[0].strip : ""
            p.departments_cities = cities.length > 0 ? cities[0].strip : ""
            p.save
          end
        end
      end
    end
  end

  # validations
  validates_with_block :json do
    @json_errors = {}
    cat_card.json.each do |key, type|
      if type[0].to_sym == :json && json[key].kind_of?(String)
        begin
          json[key] = MultiJson.load(json[key])
        rescue Exception => e
          @json_errors[key] = e.message.force_encoding('utf-8')
        end
      end
    end
    if @json_errors.any?
      [false, I18n.t('datamapper.errors.messages.json_error')]
    else
      true
    end
  end

  # instance helpers

  # class helpers
  def self.filter_by( object )
    case object.class.name
    when 'CatCard'
      all :cat_card_id => object.id
    when 'CatGroup'
      filter_strings = []
      filter_regexes = []
      while object
        object.json.each do |key,value|
          filter_strings << 'json REGEXP ?'
          filter_regexes << /\"#{key}\"\:\"#{value}\"/
        end
        object = object.parent
      end
      filter = [filter_strings.join(' AND ')]
      filter += filter_regexes

      if filter[0].length > 0
        all :conditions => filter
      else
        all
      end
    else
      all
    end
  end
end
