Admin.controllers :cat_nodes do

  before :edit, :update, :destroy do
    @object = CatNode.get(params[:id])
    unless @object
      flash[:error] = pat('object.not_found')
      redirect url(:cat_nodes, :index)
    end
  end

  get :index do
    @objects = CatNode.all
    @group = CatGroup.by_slug params[:group]
    @objects = @objects.filter_by(@group)  if @group
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
    if @object.update(params[:cat_node])
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
