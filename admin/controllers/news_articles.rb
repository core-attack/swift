Admin.controllers :news_articles do

  before :edit, :update, :destroy do
    @object = NewsArticle.get(params[:id])
    unless @object
      flash[:error] = pat('object.not_found')
      redirect url(:news_articles, :index)
    end
  end

  before :create, :update do
    create_event = params[:news_article].delete('has_event')
    if create_event
      durc = params[:news_article].delete( 'duration_count' ).to_i
      duru = params[:news_article].delete( 'duration_units' )
      event_attributes = params[:news_article].reject{|k,v|k=='publish_at'}
      event_attributes[:duration] = "#{durc}.#{duru}"
      @new_event = NewsEvent.create(event_attributes)
    end
  end

  get :index do
    filter = {}
    unless params[:news_rubric].blank?
      filter[:news_rubric_id] = NewsRubric.by_slug( params[:news_rubric] ).id  rescue nil
    end
    @objects = NewsArticle.all filter
    render 'news_articles/index'
  end

  get :new do
    @object = NewsArticle.new
    render 'news_articles/new'
  end

  post :create do
    @object = NewsArticle.new(params[:news_article])
    if @object.save
      flash[:notice] = pat('news_article.created')
      redirect url(:news_articles, :index)
    else
      render 'news_articles/new'
    end
    
  end

  get :edit, :with => :id do
    render 'news_articles/edit'
  end

  put :update, :with => :id do
    if @object.update(params[:news_article])
      flash[:notice] = pat('news_article.updated')
      redirect url(:news_articles, :index)
    else
      render 'news_articles/edit'
    end
  end

  delete :destroy, :with => :id do
    if @object.destroy
      flash[:notice] = pat('news_article.destroyed')
    else
      flash[:error] = pat('news_article.not_destroyed')
    end
    redirect url(:news_articles, :index)
  end
end
