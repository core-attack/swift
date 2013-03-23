#coding:utf-8
class FormsResult
  include DataMapper::Resource

  property :id,         Serial
  property :created_at, DateTime
  property :origin,     String, :length => 31
  property :number,     Integer

  amorphous!

  # relations
  belongs_to :forms_card, :required => true
  belongs_to :created_by, 'Account', :required => false

  # hookers
  before :valid? do
    self.origin = origin[0..30]
    self.number = FormsResult.all( :forms_card => Bond.children_for(forms_card, 'FormsCard') + [forms_card], :id.not => id ).max(:number).to_i + 1
  end
  
  # validations
  validates_with_block :json do
    @json_errors = {}
    forms_card.json.each do |key, type|
      if type[2] && json[key].blank?
        @json_errors[key] = I18n.t('datamapper.errors.messages.json_required')
      end
    end
    if @json_errors.any?
      [false, I18n.t('datamapper.errors.messages.json_error')]
    else
      true
    end
  end

  after :save do
    forms_card.reset_statistic     
  end

  # instance helpers
  def title
    I18n.l( self.created_at, :format => :datetime )
  end

  # class helpers

end
