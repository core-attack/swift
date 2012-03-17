#coding:utf-8
module Padrino
  module Helpers
    module FormBuilder
      class AdminFormBuilder < AbstractFormBuilder
        include TagHelpers
        include FormHelpers
        include AssetTagHelpers
        include OutputHelpers

        def input( field, options={} )
          object = @object.class.to_s.downcase
          html = label( field, options[:label] || { :caption => I18n.t("models.object.attributes.#{field}") })
          html += ' (' + options.delete(:brackets) + ')'  if options[:brackets]
          html += ' ' + error_message_on( object, field ) + ' '
          html += case options.delete(:as)
          when :text, :textarea, :text_area
            opts = { :class => 'text_area' }
            opts[:class] += ' markdown'  if options[:markdown]
            if options[:code]
              opts[:class] += ' code'
              opts[:spellcheck] = 'false'
            end
            opts[:value] = options[:value]  if options[:value]
            text_area field, opts
          when :password
            password_field field, :class => :password_field
          when :select
            select field, { :class => :select }.merge( options )
          when :boolean, :checkbox
            check_box field, :class => :check_box
          when :file
            loaded = @object.send(:"#{field}?")  rescue false
            tag = if loaded
              file = @object.send(field)
              I18n::t('asset_uploaded') + content_tag( :div ) do
                if file.content_type.index('image')
                  image_tag(file.url)
                else
                  link_to file.url, file.url
                end
              end
            else
              ''
            end
            input = if options[:multiple]
              file_field_tag "#{object}[#{field}][]", options
            else
              file_field( field, options )
            end
            tag + input
          when :datetime
            text_field field, :class => 'text_field datetime_picker'
          else
            text_field field, :class => :text_field
          end
          html += ' ' + @template.content_tag( :span, options[:description], :class => :description )
          @template.content_tag( :div, html, :class => :group )
        end

        def inputs( *args )
          options = {}
          options = args.pop  if args.last.kind_of? Hash
          args.map{ |f| input(f, options) }.join("\n")
        end

        def submits( options={} )
          html = @template.submit_tag options[:save_label] || I18n.t('padrino.admin.form.save'), :class => :button
          html += ' ' + @template.submit_tag( options[:back_label] || I18n.t('padrino.admin.form.back'), :onclick => "history.back();return false", :class => :button )
          @template.content_tag( :div, html, :class => 'group navform wat-cf' )
        end

      end
    end
  end
end