﻿@opts[:kind] ||= :form
if md = @swift[:slug].match( /(show|post)\/(.*)/ )
  @swift[:skip_view]['Forms'] = true
  @swift[:slug] = md[2]
  @swift[:path_pages] << Page.new
  @opts[:method] = md[1]
  if @opts[:method] == 'post' && @swift[:method] != 'POST' # FIXME ugly
    return redirect :back #@swift[:uri].gsub( /post/, 'show' )
  else
    return element( 'Forms' + @opts[:kind].to_s.camelize, @args, @opts )
  end
end
if md = @swift[:slug].match( /(poll)\/(.*)/ )
  @opts[:kind] = :inquiry
  @opts[:method] = md[1]
  @swift[:skip_view]['Forms'] = true
  @swift[:slug] = md[2]
  @swift[:path_pages] << Page.new
  return element( 'Forms' + @opts[:kind].to_s.camelize, @args, @opts )
end
@forms = FormsCard.all( :kind => @opts[:kind] ).published
