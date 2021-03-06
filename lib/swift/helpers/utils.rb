module Swift
  module Helpers
    module Utils
      def show_asset(asset, options={})
        @file = asset
        @opts = options
        element_view 'File/view'
      end

      def icon_for(filename)
        iconfile = 'images/extname/16/file_extension_'+File.extname(filename)[1..-1]+'.png'
        iconpath = Padrino.root('public', iconfile)
        if File.file?(iconpath)
          image_tag '/'+iconfile
        else
          image_tag '/images/extname/16/file_extension_bin.png'
        end
      end

      REGEX_SPLIT_IMAGE = /\[image[^\]]*?\]/.freeze

      def split_image(text)
        parts = text.partition REGEX_SPLIT_IMAGE
        [parts[1], parts[0] + parts[2]]
      end

      REGEX_IMAGE_ID = /\[image[^\]]*\s+(\d+)\s+.*?\]/.freeze

      def extract_image_object(text)
        Image.get text.match(REGEX_IMAGE_ID)[1]
      rescue
        nil
      end
    end
  end
end
