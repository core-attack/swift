def cat_groups( from, level, prefix )
  groups = CatGroup.published.all( :parent => from, :order => [:path])
  len = groups.length
  k = 1
  tree = []

  groups.each do |group|
    ensued = swift.module_path_ids.include? group.id
    master = level == 0

    leaf = {}
    leaf[:title] = group.title
    leaf[:href] = @opts[:root] ? swift.module_root.sub(/#{Regexp.escape @opts[:root]}$/, '') + group.path : swift.module_root / group.path

    leaf[:class] = master ? 'master' : 'slave'
    leaf[:class] += ' active'  if ensued

    child = false
    if ensued || @opts[:expand]
      child = cat_groups( group, level + 1, prefix + '/' + group.slug )
    end

    if child
      leaf[:class] += ' open'
      leaf[:child] = child
    else
      leaf[:class] += ' leaf'  if ensued && !master
    end

    leaf[:class] += ' first'  if k == 1
    leaf[:class] += ' last'   if k == len

    k += 1
    tree << leaf
  end

  tree
end

@opts[:expand] = true  unless @opts.has_key?(:expand)

@root_group = CatGroup.published.first(:path => @opts[:root])
@tree = cat_groups(@root_group, 1, '')
