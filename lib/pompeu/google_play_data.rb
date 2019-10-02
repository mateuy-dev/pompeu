module Pompeu
  require 'fileutils'
  GooglePlayDataStrings = Struct.new(:fulldescription, :shortdescription, :title, :whatsnew)
  class GooglePlayData
    TARGET = "google_play"
    FILES = {fulldescription: {folder: "listings", file:"fulldescription.txt"},
             shortdescription: {folder: "listings", file: "shortdescription.txt"},
             title: {folder: "listings", file: "title.txt"},
             whatsnew: {folder: "release-notes", file: "production.txt"}}

    attr_reader :strings, :language

    def initialize(strings, language)
      @strings = strings
      @language = language
    end

    def self.from_files folder_path, language
      strings = GooglePlayDataStrings.new
      FILES.each_pair do |attr, file_data|
        full_folder = File.join(folder_path, file_data[:folder], lang_folder(language))
        path = File.join(full_folder, file_data[:file])
        strings[attr] = File.read path if File.exist? path
      end
      GooglePlayData.new strings, language
    end

    def to_files folder_path, app_name
      FILES.each_pair do |attr, file_data|
        full_folder = File.join(folder_path, file_data[:folder], GooglePlayData.lang_folder(language))
        FileUtils.mkdir_p(full_folder) unless File.exist? full_folder
        path = File.join(full_folder, file_data[:file])
        value = @strings[attr]
        if :title == attr and value.length > 30
          value = app_name
        end
        File.write(path, value)
      end
    end


    # @param [TextDB] text_db
    def to_db text_db
      @strings.each_pair do |attr, value|
        text_db.add_translation TARGET, attr.to_s, @language.code, value, TranslationConfidence::UNKNOWN
      end
    end

    def self.from_db text_db, language
      lang = language.code
      strings = GooglePlayDataStrings.new
      strings.each_pair do |attr, value|
        pompeu_text = text_db.find_text(TARGET, attr.to_s)
        if pompeu_text.translation lang
          text = pompeu_text.translation(lang).text
          strings[attr] = text
        end
      end
      GooglePlayData.new strings, language
    end

    def ==(other)
      @strings == other.strings
    end

    def self.lang_folder language
      play_lang = language.for "googleplay"
    end
  end
end