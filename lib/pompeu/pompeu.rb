
require 'rubygems'
require 'yaml'
require 'nokogiri'


module Pompeu
  include Logging



  class Pompeu
    attr_accessor :project_configuration, :textDB
    def initialize configuration_file = "project_configuration.yml"
      @project_configuration = YAML.load_file(configuration_file)
      load
    end

    def db_path
      @project_configuration["paths"]["db"]
    end

    def android_path
      @project_configuration["paths"]["android"]
    end
    def languages
      @project_configuration["languages"]
    end
    def load
      if File.file? db_path
        @textDB = File.open(db_path) { |file| YAML::load( file ) }
      else
        @textDB = TextDB.new
      end
    end

    def save
      File.open(db_path, 'w') do |file|
        YAML.dump(@textDB, file)
      end
    end

    def clear_db
      File.delete db_path
    end

    #imports data form android xml files to the database
    def import_existing
      load
      languages.each do |lang|
        file = android_file lang
        if File.exist? file
          doc = File.open(file) { |f| Nokogiri::XML(f) }
          string_lines = doc.xpath("//string")
          string_lines.each do |string_line|
            key = string_line["name"]
            text = string_line.children.text
            translatable = string_line["translatable"]!="false"
            @textDB.add key, lang, text, translatable: translatable
          end
        end
      end
    end

    # writes the data to android string.xml files
    def export_android
      languages.each do |lang|
        file = "#{android_file(lang)}.v2.xml"
        File.write(file, to_xml(lang))
        puts file
      end
    end
    # creates string.xml file contents for android
    def to_xml lang
      builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
        @textDB.to_xml lang, xml
      end
      builder.to_xml(indent: 4)
    end

    def android_file lang
      values_folder = lang=="en" ? "values" : "values-#{lang}"
      "#{android_path}#{values_folder}/strings.xml"
    end

    # Returns a Text given its key
    def text_for_key key
      @textDB.texts[key]
    end
  end

  Logging.logger.warn "Pompeu - translatable are not updated"
  Logging.logger.warn "Pompeu - removed texts are not removed"
end



