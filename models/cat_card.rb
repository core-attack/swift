#coding:utf-8
class CatCard
  include DataMapper::Resource

  Types = {
    'Строка'   => :string,
    'Число'    => :number,
    'Вариант'  => :select,
    'Выборка'  => :multiple,
    'Файлы'    => :assets,
    'Картинки' => :images,
    'Объект'   => :json,
  }

  property :id,       Serial

  property :title,    String, :required => true
  property :text,     Text

  sluggable!
  timestamps!
  userstamps!
  amorphous!
  bondable!

  # relations
  has n, :cat_nodes

  # hookers

  # instance helpers

end
