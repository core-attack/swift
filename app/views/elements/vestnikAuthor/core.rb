id = request.params["id"].to_i
@author = CatNode.first(:cat_card_id => 3, :id => id)
@orgs = []
if @author
  @author["Организации"].each do |org_id|
    @orgs << CatNode.get(org_id.to_i)  
  end
end