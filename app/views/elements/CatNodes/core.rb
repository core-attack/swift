﻿unless @nodes
  @nodes = CatNode.all :cat_card_id => @card_ids
  @nodes = @nodes.filter_by(@group)  if @group
end
