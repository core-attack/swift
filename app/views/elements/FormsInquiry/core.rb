﻿case (@opts[:method] || :show).to_sym
when :poll
  @card = FormsCard.by_slug @swift[:slug]
  not_found  unless @card

  if @card.forms_results.first( :origin => request.addr )
    flash[:notice] = 'Already polled'
    redirect back
  end

  unless session['forms_cards'].include? @card.id
    flash[:notice] = 'Session severed'
    redirect back
  end

  @swift[:path_pages][-1] = Page.new :title => @card.title
  @result = @card.fill request
  if @result.saved?
    flash[:notice] = 'Saved'
    redirect back
  else
    flash[:notice] = 'Error'
  end
else
  @cards = Bond.children_for( @page, 'FormsCard' )
  @cards = FormsCard.all( :kind => 'inquiry', :order => :created_at.desc, :limit => 1 ).published  if @cards.empty?
end
