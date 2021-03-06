#coding:utf-8
require 'digest/sha2'

ACCOUNT_GROUPS = %W(admin designer auditor editor robot user)

class Account
  include DataMapper::Resource
  include DataMapper::Validate
  attr_accessor :password, :password_confirmation

  class << self
    attr_accessor :current
  end

  # Properties
  property :id,               Serial
  property :name,             String
  property :surname,          String
  property :email,            String
  property :crypted_password, String, :length => 70

  # for omniauth
  property :provider,         String
  property :uid,              String

  # Validations
  validates_presence_of      :email, :message => I18n.t('datamapper.errors.email.presense')
  validates_uniqueness_of    :email, :message => I18n.t('datamapper.errors.email.uniqueness'), :case_sensitive => false
  validates_format_of        :email, :message => I18n.t('datamapper.errors.email.format'),     :with => /\w+@\w+/
  validates_with_block :password do
    case 
    when crypted_password.present? && password.blank? && password_confirmation.blank?
      true
    when password.to_s.length < 4
      [false, I18n.t('models.account.password.must_be_long')]
    when password != password_confirmation
      [false, I18n.t('models.account.password.not_confirmed')]
    else
      true
    end
  end

  timestamps!
  userstamps!
  loggable!
  property :logged_at, DateTime

  # relations
  has n, :folders
  property :group_id, Integer, :default => 6, :writer => :protected
  belongs_to :group, 'Account', :required => false

  # hookers
  before :save do
    self.crypted_password = encrypt_password  if password.present?
  end

  before :destroy do |a|
    throw halt  unless a.group
  end

  # instance helpers
  def get_folders
    #!!! do more logic
    Folder.all
  end

  def allowed( check )
    return group.allowed(check)  if group
    raise Forbidden  if id > ACCOUNT_GROUPS.length
    check_index = ACCOUNT_GROUPS.index(check.to_s)
    self_index  = ACCOUNT_GROUPS.index(name.to_s)
    return true  if self_index <= check_index
  end
  alias allowed? allowed

  def has_access_to( object, operation = nil ) # FIXME
    operation_allowed = case operation
    when :approve
      allowed( :auditor )
    when :delete
      allowed( :editor )
    else
      true
    end
    return false  unless operation_allowed
    
    case
    when allowed( :admin )
      true
    when allowed( :auditor )
      object.created_by.archive_id == archive_id
    when allowed( :editor )
      object.created_by_id == id
    else
      false
    end
  end

  def all_accessible( object_model ) # FIXME
    filter = case
    when allowed( :admin )
      {}
    when allowed( :auditor )
      { 'created_by.archive_id' => archive.id }
    else
      { 'created_by_id' => id }
    end
    object_model.to_s.singularize.camelize.constantize.all filter
  end

  def role
    group ? group.role : name
  end

  def role_title
    group ? group.role_title : title
  end

  def title
    group_id ? "#{name} #{surname}" : I18n.t("group.#{name}")
  end

  def has_password?(pwd)
    crypted_password == encrypt_password(pwd)
  end

  def reset_code
    Digest::SHA2.hexdigest(Digest::SHA1.hexdigest(attributes.inspect) + 'hrjovFas8' + Date.today.to_s)[6..11]
  end

  def new_password
    random_password = `apg -qd -c#{rand(0..9)} -m8 -x8 -n1`  rescue Digest::SHA2.hexdigest(DateTime.now.to_s+rand.to_s).gsub(/[^\d]/,'')[0..5]
    self.password = self.password_confirmation = random_password
    self.crypted_password = encrypt_password
    random_password
  end

  # class helpers
  def self.authenticate(credentials)
    case
    when credentials[:email] && credentials[:password]
      account = first( :email => credentials[:email] )
      if account && account.has_password?(credentials[:password])
        account.logged_at = DateTime.now
        account.save!
        account
      end
    when credentials.has_key?(:id)
      get(credentials[:id].to_i)
    else
      false
    end
  end

  def self.find_by_id(id)
    get(id) rescue nil
  end

  def self.create_with_omniauth(auth)
    attributes = { :provider => auth['provider'] }
    by_uid = attributes.merge :uid => auth['uid']
    by_email = attributes.merge :email => auth['info']['email']

    if account = (Account.first(by_uid) || Account.first(by_email))
      account.update! :logged_at => DateTime.now, :uid => auth['uid']
      account
    else
      password = Digest::SHA2.hexdigest("#{DateTime.now}5ovCu#{rand}Cy")[4..11]
      attributes.merge!(by_uid).merge!(by_email).merge!(
        :name     => auth['info']['name'],
        :password => password,
        :password_confirmation => password,
      )
      attributes[:email] = "#{auth['uid']}.#{auth['provider']}@localhost" if attributes[:email].blank?
      account = Account.create(attributes)
      if Padrino.env == :development && Account.count(:group_id.not => nil, :id.not => account.id) == 0
        account.group = Account.get(1)
        account.save!
      end
      account
    end
  end

  private

  def encrypt_password(pwd = password)
    Digest::SHA2.hexdigest("==#{created_at}==yudBuHid5==#{pwd}==")
  end
end
