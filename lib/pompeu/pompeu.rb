require 'rubygems'
require 'yaml'
require 'nokogiri'


module Pompeu
  include Logging

  Logging.logger.warn "Pompeu - translatable are not updated"
  Logging.logger.warn "Pompeu - removed texts are not removed"


  class Pompeu
    include Logging
    attr_accessor :project_configuration, :text_db

    def initialize configuration_file = "project_configuration.yml"
      @project_configuration = YAML.load_file(configuration_file)
      @db_path = @project_configuration["paths"]["db"]
      @user_languages = @project_configuration["user-languages"]
      @languages = Language.load_map(@project_configuration["languages"])
      @default_language = @project_configuration["default_language"]
      @app_name = @project_configuration["app_name"]
      @text_db_serializer = TextDbSerializer.new @db_path
      @text_db = @text_db_serializer.load_file


      @sources = @project_configuration["translatables"].map do |translatable|
        type = translatable["type"]
        path = translatable["path"]
        target = translatable["target"] || translatable["type"]
        selected_languages = translatable["languages"]
        languages = selected_languages ? @languages.select {|lang| selected_languages.include? lang.code} : @languages
        case type
        when "android"
          AndroidSource.new @text_db, languages, @default_language, path, target
        when "googleplay"
          GooglePlaySource.new @text_db, languages, path
        when "rails"
          RailsSource.new @text_db, languages, path, target
        end
      end
      @pip_cache = PipTranslateCache.new @project_configuration["paths"]["internal"]
      @web_cache = WebResponseCache.new @project_configuration["paths"]["internal"]
      @auto_translate = AutoTranslate.new(@text_db, @languages, @default_language, @web_cache, @pip_cache)

      @auto_translate_2check = AutoTranslateWithDoubleCheck.new(@text_db, @default_language, @auto_translate.google_free_translator_with_python)

      @reuse_translate = ReuseTranslate.new(@text_db, @languages, @default_language)
    end

    def save
      @text_db_serializer.save @text_db
    end

    def import language
      @sources.each {|source| source.import @languages.select{|lang| lang.code == language}[0]}
    end

    def import_all
      @sources.each {|source| source.import_all}
    end

    def export
      @sources.each {|source| source.export @app_name}
    end

    def import_gengo_translation file, lang
      Gengo.new.import @text_db, file, lang
    end

    def export_for_gengo language, confidence, target, origin_language = nil
      origin_language ||= @default_language
      texts = @text_db.untranslated_or_worse_than language, origin_language, confidence, target
      puts Gengo.new.export(texts, origin_language)
    end

    def import_csv_translation file, lang
      CsvExporter.new.import @text_db, file, lang
    end


    def export_for_csv language, confidence, target, origin_language = nil
      origin_language ||= @default_language
      texts = @text_db.untranslated_or_worse_than language, origin_language, confidence, target
      puts CsvExporter.new.export(texts, origin_language, language)
    end

    def export_for_csvv0(language, confidence, target, origin_language = nil)
      origin_language ||= @default_language
      texts = @text_db.untranslated_or_worse_than language, origin_language, confidence, target
      puts CsvImportExport.new.export(texts, origin_language)
    end

    def auto_translate(min_quality = TranslationConfidence::AUTO)
      @auto_translate.translate min_quality
    end

    def auto_translate_double_check(end_lang, min_times = 2, min_quality = TranslationConfidence::AUTO)
      @auto_translate_2check.translate(end_lang, min_times, min_quality)
    end

    def auto_translate_reusing(min_quality = TranslationConfidence::PROFESSIONAL_REUSED)
      @reuse_translate.translate(min_quality)
    end


    def interactive_translate language
      interactive_translate = InteractiveTranslate.new @text_db, @default_language, @auto_translate
      interactive_translate.translate language
    end

    def clear_database
      @text_db_serializer.clear
      @text_db.clear
    end


  end

end



