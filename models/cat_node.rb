#coding: utf-8
class CatNode
  include DataMapper::Resource

  property :id,       Serial

  property :title,    String, :required => true
  property :text,     Text
  
  sluggable!
  timestamps!
  userstamps!
  publishable!
  bondable!
  amorphous!

  # relations
  belongs_to :cat_card, :required => true

  # hookers
  #before :valid? do 
  #  #
  #  cat_card.json.each do |key, type|
  #    if type[0].to_sym == :json && json[key].kind_of?(String)
  #      begin
  #        json[key] = MultiJson.load(json[key])
  #      rescue Exception => e
  #        $logger.warn 'erroneous json'
  #      end
  #    end
  #  end
  #end
  
  validates_with_block :json do
    @json_errors = {} # !!! FIXME initialize json_errors somewhere
    cat_card.json.each do |key, type|
      if type[0].to_sym == :json && json[key].kind_of?(String)
        begin
          json[key] = MultiJson.load(json[key])
        rescue Exception => e
          #had_error << [key,e.message.encode('utf-8', :invalid => :replace, :undef => :replace)]
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
  def self.filter_by( group )
    filter_strings = []
    filter_regexes = []
    while group
      group.json.each do |key,value|
        filter_strings << 'json REGEXP ?'
        filter_regexes << /\"#{key}\"\:\"#{value}\"/
      end
      group = group.parent
    end
    filter = [filter_strings.join(' AND ')]
    filter += filter_regexes

    if filter[0].length > 0
      all :conditions => filter
    else
      all
    end
  end

end
