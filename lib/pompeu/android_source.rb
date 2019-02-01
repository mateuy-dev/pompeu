module Pompeu

  class AndroidSource
    def initialize textDB, languages, default_language, android_path, target
      @textDB = textDB
      @languages = languages
      @android_path = android_path
      @default_language = default_language
      @target = target
    end

    #imports data form android xml files to the database
    def import
      @languages.each do |language|
        file = android_file_path(language)
        next unless File.exist? file
        android_file = AndroidFile.from_files file, @target
        android_file.to_db @textDB, language.code
      end
    end

    # writes the data to android string.xml files
    def export(_appname = nil)
      @languages.each do |language|
        folder = android_folder(language)
        unless File.exist?(folder)
          Logging.logger.warn "Pompeu - creating folder for android language #{language.code}: #{folder}"
          Dir.mkdir folder
        end
        file = android_file_path(language)
        android_file = AndroidFile.from_db @textDB, language.code, @target
        android_file.to_files file
      end
    end

    def android_file_path language
      File.join android_folder(language), "strings.xml"
    end

    def android_folder language
      android_lang = language.for "android"
      values_folder = language.code == @default_language ? "values" : "values-#{android_lang}"
      File.join @android_path, values_folder
    end
  end
end