# coding:utf-8
class String
  # Allows to connect with `/`
  # 'foo' / :bar # => 'foo/bar'
  def / (s)
    "#{self}/#{s.to_s}"
  end

  # Transliterate the string and make it uri-friendly
  def as_slug
    Swift::Transliteration.slugize self
  end

  # case convert for cyrillic strings
  def case( dir )
    case dir
    when :up, :upper
      Swift::CaseConversion.upcase self
    when :lo, :low, :lower, :down
      Swift::CaseConversion.downcase self
    when :cap
      Swift::CaseConversion.capitalize self
    else
      self
    end
  end
end

class Symbol
  # Allows symbols to connect with `/`
  # :foo / :bar # => 'foo/bar'
  def / (s)
    "#{self.to_s}/#{s.to_s}"
  end
end

# NilClass returns nil for any?
class NilClass
  def any?
    nil
  end
end

# display date as span with tooltip
class Date
  def as_span
    %(<span rel="tooltip" data-original-title="#{self.as_date.strip}">#{self.to_s}</span>)
  end
end

class Object
  # Shows size as human-readable number of bytes
  def as_size( s = nil )
    prefix = %W(Тб Гб Мб Кб б)
    s = (s || self).to_f
    i = prefix.length - 1
    while s > 512 && i > 0
      s /= 1024
      i -= 1
    end
    ((s > 9 || s.modulo(1) < 0.1 ? '%d' : '%.1f') % s) + ' ' + prefix[i]
  end

  # Shows a date in locale-specific format
  def as_date( d = nil )
    d = (d || self)
    return ''  unless [Date, Time, DateTime].include? d.class
    format = d.year == Date.today.year ? 'date_same_year' : 'date_other_year'
    I18n.l d, :format => I18n.t( 'time.formats.' + format )
  end
end

module Kernel
  def Logger( *args )
    if logger.respond_to? :ap
      args.each { |arg| logger.ap arg }
    else
      args.each { |arg| logger << arg.inspect }
    end
  end
end

# Implements #jo_json
[Array, Float, Hash, Integer, String, NilClass, TrueClass, FalseClass].each do |klass|
  klass.class_eval do
    def to_json(options = {})
      MultiJson.encode(self, options)
    end
  end
end
class Time
  def to_json(options = nil)
    xmlschema
  end
end
class Date
  def to_json(options = nil)
    strftime("%Y-%m-%d")
  end
end
class DateTime
  def to_json(options = nil)
    xmlschema
  end
end
class Object
  def to_json(options = nil)
    if respond_to? :as_json
      as_json.to_json
    else
      raise Exception, "MultiJson failed to serialize #{self.inspect}"
    end
  end
end

module FileUtils
  # Tries to move a file and ignores failures
  def self.mv_try( src, dst )
    return nil  if src == dst
    return nil  unless File.exists? src
    FileUtils.mkpath File.dirname(dst)
    FileUtils.mv src, dst
  rescue ArgumentError
    nil
  end
end