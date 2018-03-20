require 'rubygems'
require 'yaml'
require 'nokogiri'


module Pompeu
  include Logging

  Logging.logger.warn "Pompeu - translatable are not updated"
  Logging.logger.warn "Pompeu - removed texts are not removed"


  class Pompeu
    include Logging
    attr_accessor :project_configuration, :textDB
    def initialize configuration_file = "project_configuration.yml"
      @project_configuration = YAML.load_file(configuration_file)
      @db_path = @project_configuration["paths"]["db"]
      @android_path = @project_configuration["paths"]["android"]
      @googleplay_path = @project_configuration["paths"]["googleplay"]
      @rails_path = @project_configuration["paths"]["rails"]
      @languages = Language.load_map(@project_configuration["languages"])
      @default_language = @project_configuration["default_language"]

      @text_db_serializer = TextDbSerializer.new @db_path
      @text_db = @text_db_serializer.load_file
      @android_source = AndroidSource.new @text_db, @languages, @default_language, @android_path if @android_path
      @google_play_source = GooglePlaySource.new @text_db, @languages, @googleplay_path if @googleplay_path
      @rails_source = RailsSource.new @text_db, @languages, @rails_path if @rails_path

    end

    def save
      @text_db_serializer.save @text_db
    end

    def import
      @android_source.import if @android_source
      @google_play_source.import if @google_play_source
      @rails_source.import if @rails_source
    end

    def export
      @android_source.export if @android_source
      @google_play_source.export if @google_play_source
      @rails_source.export if @rails_source
    end

    def export_for_gengo language, confidence
      texts = @text_db.untranslated_or_worse_than language, @default_language, confidence
      Gengo.new.export(texts, @default_language)
    end

    def auto_translate(min_quality = TranslationConfidence::AUTO)
      auto_translate = AutoTranslate.new @text_db, @languages, @default_language
      auto_translate.translate min_quality
    end

    def interactive_translate language
      interactive_translate = InteractiveTranslate.new @text_db, @default_language
      interactive_translate.translate language
    end

    def clear_database
      @text_db_serializer.clear
      @text_db.clear
    end

  end

end



