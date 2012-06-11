#coding:utf-8
ACCOUNT_GROUPS = %W(admin designer auditor editor robot user)

class Account
  include DataMapper::Resource
  include DataMapper::Validate
  attr_accessor :password, :password_confirmation

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
  validates_presence_of      :email
  validates_length_of        :email,    :min => 3, :max => 100
  validates_uniqueness_of    :email,    :case_sensitive => false
  validates_format_of        :email,    :with => /\w+@\w+/
  validates_presence_of      :password,                          :if => :password_required
  validates_presence_of      :password_confirmation,             :if => :password_required
  validates_length_of        :password, :min => 4, :max => 40,   :if => :password_required
  validates_confirmation_of  :password,                          :if => :password_required

  timestamps!
  userstamps!
  property :logged_at, DateTime

  # relations
  has n, :folders
  property :group_id, Integer, :default => 6, :writer => :protected
  belongs_to :group, 'Account', :required => false

  # hookers
  before :save, :encrypt_password

  before :destroy do |a|
    throw halt  unless a.group
  end

  # instance helpers
  def get_folders
    #!!! do more logic
    Folder.all
  end

  def allowed( check )
    return self.group.allowed(check)  if self.group
    raise Forbidden  if self.id > ACCOUNT_GROUPS.length
    check_index = ACCOUNT_GROUPS.index(check.to_s)
    self_index  = ACCOUNT_GROUPS.index(self.name.to_s)
    return true  if self_index <= check_index
  end
  alias allowed? allowed

  def role
    self.group ? self.group.role : self.name
  end

  def title
    group_id ? "#{name} #{surname}" : I18n.t("group.#{name}")
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  # class helpers
  def self.authenticate(email, password)
    account = first( :email => email )  if email.present?
    if account && account.has_password?(password)
      account.logged_at = DateTime.now
      account.save
      account
    else
      nil
    end
  end

  def self.find_by_id(id)
    get(id) rescue nil
  end

  def self.create_with_omniauth(auth)
    name = email = ''
    name = auth['info']['name']
    email = auth['info']['email']
    raise Exception  if name.blank?

    email = "auto.#{auth['uid']}.#{auth['provider']}@localhost"  if email.blank?

    if account = Account.first( :uid => auth['uid'], :provider => auth['provider'] )
      account.logged_at = DateTime.now
      account.save
      account
    else
      pwd = Digest::MD5.hexdigest(rand.to_s)[4..11]
      account = Account.create :provider => auth['provider'],
                               :uid      => auth['uid'],
                               :name     => name,
                               :email    => email,
                               :password => pwd,
                               :password_confirmation => pwd
    end
  end

private

  def password_required
    uid.blank? && (crypted_password.blank? || password.present?)
  end

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) if password.present?
  end

end
