MODULE_GROUPS = {
  :content => %W(pages blocks assets images folders),
  :news    => %W(news_articles news_rubrics news_events),
  :forms   => %W(forms_cards forms_stats forms_results),
  :cat     => %W(cat_nodes cat_cards cat_groups),
  :design  => %W(layouts fragments elements codes),
  :admin   => %W(accounts options),
}
BONDABLE_CHILDREN = %W(Page Folder Image FormsCard CatCard)
BONDABLE_PARENTS  = %W(Page CatNode NewsArticle Folder)

require 'omniauth-openid'
require 'openid/store/filesystem'

class Admin < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

  register Sinatra::AssetPack

  assets do
    js_compression :simple

    serve '/stylesheets', from: '../assets/stylesheets'
    serve '/javascripts', from: '../assets/javascripts'

    css :login, [
      '/stylesheets/libraries/bootstrap.css',
      '/stylesheets/admin/96-monkey.css',
      '/stylesheets/login.css',
    ]

    css :admin, [
      '/stylesheets/libraries/bootstrap.css',
      '/stylesheets/libraries/colorbox.css',
      '/stylesheets/admin/*.css',
    ]

    js :admin, [
      '/javascripts/libraries/*.js',
      '/javascripts/bootstrap/*.js',
      '/javascripts/markdown/*.js',
      '/javascripts/fileupload/*.js',
      '/javascripts/admin-core.js',
    ]
  end

  helpers Padrino::Helpers::EngineHelpers

  set :login_page, "/admin/sessions/new"
  set :default_builder, 'AdminFormBuilder'

  `which /usr/sbin/exim` #!!! FIXME this is bullcrap
  if $?.success?
    set :delivery_method, :smtp
  else
    set :delivery_method, :sendmail
  end

  use Rack::Session::DataMapper, :key => 'swift.sid', :path => '/', :secret => 'Dymp1Shnaneu', :expire_after => 1.month

  enable :store_location

  use OmniAuth::Builder do
    provider :open_id, :store => OpenID::Store::Filesystem.new(Padrino.root+'/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
    provider :open_id, :store => OpenID::Store::Filesystem.new(Padrino.root+'/tmp'), :name => 'yandex', :identifier => 'http://ya.ru/'
  end

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
    role.allow "/assets"
    role.allow "/auth"
    role.allow "/accounts/reset"
  end

  access_control.roles_for :editor do |role|
    role.project_module :pages, "/pages"
    role.project_module :images, '/images'
    role.project_module :assets, '/assets'
    role.project_module :blocks, '/blocks'
    role.project_module :folders, '/folders'

    role.project_module :news_articles, '/news_articles'
    role.project_module :news_events, '/news_events'

    role.project_module :forms_results, '/forms_results'
    role.project_module :forms_stats, '/forms_stats'

    role.project_module :cat_nodes,  '/cat_nodes'
    role.project_module :cat_groups, '/cat_groups'
  end

  access_control.roles_for :auditor do |role|
    role.project_module :pages, "/pages"
    role.project_module :images, '/images'
    role.project_module :assets, '/assets'
    role.project_module :blocks, '/blocks'
    role.project_module :folders, '/folders'

    role.project_module :news_articles, '/news_articles'
    role.project_module :news_rubrics, '/news_rubrics'
    role.project_module :news_events, '/news_events'

    role.project_module :forms_cards, '/forms_cards'
    role.project_module :forms_stats, '/forms_stats'
    role.project_module :forms_results, '/forms_results'

    role.project_module :cat_nodes,  '/cat_nodes'
    role.project_module :cat_cards,  '/cat_cards'
    role.project_module :cat_groups, '/cat_groups'
  end

  access_control.roles_for :designer do |role|
    role.project_module :pages, "/pages"
    role.project_module :images, '/images'
    role.project_module :assets, '/assets'
    role.project_module :blocks, '/blocks'
    role.project_module :folders, '/folders'

    role.project_module :news_articles, '/news_articles'
    role.project_module :news_rubrics, '/news_rubrics'
    role.project_module :news_events, '/news_events'

    role.project_module :forms_cards, '/forms_cards'
    role.project_module :forms_stats, '/forms_stats'
    role.project_module :forms_results, '/forms_results'

    role.project_module :cat_nodes,  '/cat_nodes'
    role.project_module :cat_cards,  '/cat_cards'
    role.project_module :cat_groups, '/cat_groups'

    role.project_module :fragments,  '/fragments'
    role.project_module :layouts,    '/layouts'
    role.project_module :elements,   '/elements'

    role.project_module :codes,      '/codes'
  end

  access_control.roles_for :admin do |role|
    role.project_module :pages, "/pages"
    role.project_module :images, '/images'
    role.project_module :assets, '/assets'
    role.project_module :blocks, '/blocks'
    role.project_module :folders, '/folders'

    role.project_module :news_articles, '/news_articles'
    role.project_module :news_rubrics, '/news_rubrics'
    role.project_module :news_events, '/news_events'

    role.project_module :forms_cards, '/forms_cards'
    role.project_module :forms_stats, '/forms_stats'
    role.project_module :forms_results, '/forms_results'

    role.project_module :cat_nodes,  '/cat_nodes'
    role.project_module :cat_cards,  '/cat_cards'
    role.project_module :cat_groups, '/cat_groups'

    role.project_module :fragments,  '/fragments'
    role.project_module :layouts,    '/layouts'
    role.project_module :elements,   '/elements'

    role.project_module :options,    '/options'
    role.project_module :codes,      '/codes'
    role.project_module :accounts,   '/accounts'
  end

  # hookers
  before do
    params.each do |k,v|
      next  unless v.kind_of? Hash
      params[k].delete 'created_by_id'
      params[k].delete 'updated_by_id'
      params[k].delete 'account_id'  if params[k]['account_id'].blank?
      if Object.const_defined?(k.camelize)
        child_model = k.camelize.constantize
        params[k]['updated_by_id'] = current_account.id  if child_model.new.respond_to?(:updated_by_id)
        params[k]['account_id'] ||= current_account.id   if child_model.new.respond_to?(:account_id)
      end
    end

    @the_model = begin
      @models = request.controller || params[:controller]
      @model = @models.singularize
      @models = @models.to_sym
      @model_name = @model.camelize
      @model = @model.to_sym
      Object.const_defined?(@model_name)  or throw :undefined
      @model_name.constantize
    rescue
      nil
    end
  end

  # common routes
  post '/:controller/multiple' do
    return redirect url(:base, :index)  unless @the_model
    if params["check_#{@model}"].kind_of? Hash
      ids = params["check_#{@model}"].keys
      case params['_method']
      when 'delete'
        if @the_model.all( :id => ids ).destroy
          flash[:notice] = I18n.t('padrino.admin.multiple.destroyed', :objects => I18n.t("models.#{@models}.name"))
        else
          flash[:error] = I18n.t('padrino.admin.multiple.not_destroyed', :objects => I18n.t("models.#{@models}.name"))
        end
      when 'publish'
        break  unless @the_model.respond_to? :published
        @the_model.all( :id => ids ).to_a.each{ |o| o.publish! } #FIXME to_a for redis
        flash[:notice] = I18n.t('padrino.admin.multiple.published', :objects => I18n.t("models.#{@models}.name"))
      when 'unpublish'
        break  unless @the_model.respond_to? :published
        @the_model.all( :id => ids ).to_a.each{ |o| o.unpublish! } #FIXME to_a for redis
        flash[:notice] = I18n.t('padrino.admin.multiple.unpublished', :objects => I18n.t("models.#{@models}.name"))
      end
    end
    redirect url(@models, :index)
  end

  get '/:controller/multiple' do
    redirect url(@the_model ? @models : :base, :index)
  end

  def do_auth(request)
    auth    = request.env["omniauth.auth"]
    account = Account.create_with_omniauth(auth)
    if account.saved?
      set_current_account account
      redirect_back_or_default url(:base, :index)
    else
      flash[:error] = account.errors.to_a.flatten.join(', ') + ': ' + content_tag(:code, "#{account.email}<br>#{account.provider}: #{account.uid}")
      set_current_account nil
      redirect url(:sessions, :new)
    end
  end

  post '/auth/:provider/callback' do
    do_auth request
  end

  get '/auth/:provider/callback' do
    do_auth request
  end

  get '/auth/failure' do
    flash[:error] = t 'login.error.' + params[:message]
    redirect '/admin/session/new'
  end

end
