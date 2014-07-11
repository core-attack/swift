#coding:utf-8

require 'mysql'
require 'builder'
require 'date'
require 'fileutils'

namespace :udsu do
  desc "reading xml file..."
  task :read_xml => :environment do
    Dir.glob('xmls/*.xml').each do |xml|
      d = Nokogiri::XML(File.open(xml))
      departments = []
      doc.css("ФАКУЛЬТЕТ").each do |dep|
        directions_list => directions_list = []
        dep.css("НАПРСПЕЦ").each do |dir|
          direction = {:code => dir.attribute("code"), 
                      :okso => dir.attribute("okso"), 
                      :name => dir.attribute("name1"), 
                      :edu_level => dir.attribute("edu_level"), 
                      :all => dir.css("ВЫПУСК_ВСЕГО"), 
                      :has_job => dir.css("ТРУДОУСТРОЕНО_ВСЕГО"), 
                      :has_quality_job => dir.css("ТРУДОУСТРОЕНО_СПЕЦ")}
          directions_list << direction
        end
        dep_info = {:id => dep.attribute("id"), :short_name => dep.attribute("short_name"), :name => dep.attribute("name"), :year => dep.attribute("year"), :directions_list => directions_list}
      end
    end
  end
end