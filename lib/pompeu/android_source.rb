module Pompeu

  class AndroidSource
  def initialize textDB, languages, default_language, android_path
      @textDB = textDB
      @languages = languages
      @android_path = android_path
      @default_language = default_language
    end

    #imports data form android xml files to the database
    def import
      @languages.keys.each do |lang|
        file = android_file_path(lang)
        next unless File.exist? file
        android_file = AndroidFile.from_files file
        android_file.to_db @textDB, lang
      end
    end

    # writes the data to android string.xml files
    def export
      @languages.keys.each do |lang|
        folder = android_folder(lang)
        unless File.exist?(folder)
          Logging.logger.warn "Pompeu - creating folder for android language #{lang}: #{folder}"
          Dir.mkdir folder
        end
        file = android_file_path(lang)
        android_file = AndroidFile.from_db @textDB, lang
        android_file.to_files file
      end
    end

    def android_file_path lang
      File.join android_folder(lang), "strings.xml"
    end

    def android_folder lang
      android_lang = @languages[lang]["android"]
      values_folder = lang==@default_language ? "values" : "values-#{android_lang}"
      File.join @android_path, values_folder
    end
  end
end