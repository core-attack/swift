Admin.controllers :forms_results do

  before :edit, :destroy do
    @object = FormsResult.get(params[:id])
    unless @object
      flash[:error] = pat('object.not_found')
      redirect url(:forms_results, :index)
    end
  end

  get :index do
    filter = {}
    if params[:forms_card_id]
      filter[:forms_card_id] = params[:forms_card_id].to_i  unless params[:forms_card_id] == 'all'
    else
      filter[:forms_card_id] = params[:forms_card_id] = FormsCard.last.id  
    end
    filter[:order] = :created_at.desc
    @objects = FormsResult.all filter
    render 'forms_results/index'
  end

  get :edit, :with => :id do
    @object = FormsResult.get(params[:id])
    render 'forms_results/edit'
  end

  delete :destroy, :with => :id do
    @object = FormsResult.get(params[:id])
    if @object.destroy
      flash[:notice] = pat('forms_result.destroyed')
    else
      flash[:error] = pat('forms_result.not_destroyed')
    end
    redirect url(:forms_results, :index)
  end
end
