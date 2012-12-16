Admin.helpers do
  def mk_edit( target )
    link_to( target.title, url(target.class.storage_name.to_sym, :edit, :id => target.id), :class => :edit )
  end

  def mk_checkbox( target, sorter = nil )
    name = :"check_#{target.class.name.underscore}[#{target.id}]"
    content = mk_published( target ) + check_box_tag( name, :checked => false, :id => name )
    content_tag :label, content, :for => name, :class => :checkbox, :'data-sorter' => (sorter || target.id)
  end

  def mk_published( target )
    return ''  unless target.respond_to? :is_published
    content_tag( :i, '', :class => 'icon-'+(target.is_published ? 'ok' : 'ban-circle') ) + ' '
  end

load 'icons.rb'

  def mk_glyph( s, opt = {} )
    s = s.to_s
    s += ' icon-white'  if opt.delete( :white )
    content_tag( :i, '', { :class => 'icon-'+s }.merge(opt) )
  end

  def mk_glyphs( *ss )
    ret = ''
    ss.each do |s|
      ret += content_tag( :i, '', :class => 'icon-'+s )
    end
    ret
  end

  def mk_multiple_op( op )
    link_to mk_icon(op) + pat(op), :method => op, :class => 'multiple btn'
  end

  def mk_single_op( op, link )
    link_to mk_icon(op) + pat(op), link, :class => :single
  end

  def mk_dialog_op( op, link, opts={} )
    name = content_tag(:u, mk_icon(op) + pat(op) + (opts.delete(:add)||''))
    link_to name, link, opts.merge(:class => 'single dialog', :'data-toggle' => :modal)
  end

  def mk_button_op( op, link )
    op = :delete  if op == :destroy
    link_to mk_icon(op) + pat(op), link, :method => op, :class => 'single button_to'
  end

  def allow role
    if current_account.allowed role
      @allowed = role
      yield
      @allowed = nil
    end
  end

  def page_tree( from, level, prefix )
    pages = Page.all :parent_id => from, :order => [:position, :path]
    return false  unless pages.length > 0

    tree = []
    pages.each do |page|
      tree << { :page => page,
                :child => page_tree(page.id, level + 1, prefix + '/' + page.slug) }
    end
    return tree
  end

  def tree_flat( tree )
    ret = []
    (tree||[]).each do |leaf|
      ret << leaf[:page]
      ret += tree_flat(leaf[:child])
    end
    ret.compact
  end

end
