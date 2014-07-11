#coding:utf-8
Admin.controllers :cat_nodes do

  before :edit, :update, :destroy do
    @object = CatNode.get(params[:id])
    unless @object
      flash[:error] = pat('object.not_found')
      redirect url(:cat_nodes, :index)
    end
  end
  
  before :edit, :update do
    @object = CatNode.get(params[:id])
    if @object.cat_card_id == 2
      
      key = "Авторы"
      #!!!!!!!
      #@object.json[key] = []
      #
      unless @object.json[key]
        @object.json[key] = []
      end
      authors = []
      if @object.json.length > 0
        @object.json[key].each do |author_id|
          author = CatNode.get(author_id.to_i)
          authors << author.title + "," + author.id.to_s
        end
      end
      authors.sort!
      @object.authors_names = authors.length > 0 ? authors.join(';') : ""
      key = "Публикующие организации"
      unless @object.json[key]
        @object.json[key] = []
      end
      departments = []
      countries = []
      cities = []
      if @object.json.length > 0
        @object.json[key].each do |department_id|
          dep = CatNode.get(department_id.to_i)
          unless dep.blank?
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
      end
      departments.sort!
      countries.sort!
      cities.sort!
      @object.departments_names = departments.length > 0 ? departments.join(';').to_s : ""
      @object.departments_countries = countries.length > 0 ? countries.join(';') : ""
      @object.departments_cities = cities.length > 0 ? cities.join(';') : ""
      unless @object.json['Год'].blank?
        @object.publication_year = @object.json['Год']
      end
      unless @object.json['Номер выпуска'].blank?    
        @object.publication_issue = @object.json['Номер выпуска'] 
      end
      unless @object.json['Номер в выпуске'].blank?
        @object.publication_number = @object.json['Номер в выпуске'] < 10 ? @object.json['Номер в выпуске'].to_s : @object.json['Номер в выпуске']
      end
      unless @object.json['Раздел'].blank?
        @object.publication_part = @object.json['Раздел']
      end
      i = @object.json['Номер выпуска'].to_s
      n = @object.json['Номер в выпуске'].to_s
      @object.publication_yin = "#{@object.json['Год']}-#{i.length == 1 ? "0#{i}" : i}-#{n.length == 1 ? "0#{n}" : n}"
      @object.save
    end
  end
  
  get :index do
    @objects = CatNode.all
    filter = {}
    if params[:card_id]
      filter[:card_id] = params[:card_id].to_i  unless params[:card_id] == 'all'
    else
      cat_card = CatCard.last
      filter[:card_id] = params[:card_id] = cat_card.id  if cat_card
    end
    @card = CatCard.get filter[:card_id]
    @groups = @card ? CatGroup.all( :cat_card_id => @card.id ) : []
    @group = CatGroup.get params[:group_id].to_i
    @objects = @objects.filter_by(@card).filter_by(@group)
    render 'cat_nodes/index'
  end

  get :new do
    @object = CatNode.new
    render 'cat_nodes/new'
  end

  post :create do
    @object = CatNode.new(params[:cat_node])
    if @object.save
      flash[:notice] = pat('cat_node.created')
      redirect url(:cat_nodes, :edit, :id => @object.id) #!!! FIXME should load actual fields on :new, maybe xhr
    else
      render 'cat_nodes/new'
    end
  end

  get :edit, :with => :id do
    @object = CatNode.get(params[:id])
    render 'cat_nodes/edit'
  end

  put :update, :with => :id do
    @object = CatNode.get(params[:id])
    attributes = {}
    #throw params[:cat_node]
    params[:cat_node].each do |k,v|
      if card_field = @object.cat_card.json[k]
        case card_field[0]
        when 'assets', 'images'
          value = MultiJson.load(v)  rescue nil
          attributes[k] = value  if value
        when "number"
          attributes[k] = v.to_i
        else
          attributes[k] = v
        end
      else
        attributes[k] = v
      end
    end
    if @object.update(attributes)
      #throw @object
      flash[:notice] = pat('cat_node.updated')
      redirect url_after_save
    else
      render 'cat_nodes/edit'
    end
  end

  delete :destroy, :with => :id do
    @object = CatNode.get(params[:id])
    if @object.destroy
      flash[:notice] = pat('cat_node.destroyed')
    else
      flash[:error] = pat('cat_node.not_destroyed')
    end
    redirect url(:cat_nodes, :index)
  end
  
end
