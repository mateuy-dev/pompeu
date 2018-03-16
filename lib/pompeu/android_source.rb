module Pompeu
  AndroidString = Struct.new(:key, :text, :translatable)
  class AndroidSource


    def initialize textDB, languages, android_path, default_language="en"
      @textDB = textDB
      @languages = languages
      #@pompeu.project_configuration["paths"]["android"]
      @android_path = android_path
      @default_language = default_language
    end

    #imports data form android xml files to the database
    def import
      @languages.each do |lang|
        file = android_file_path(lang)
        next unless File.exist? file
        android_file = AndroidFile.from_xml_file file
        android_file.to_text_db @textDB, lang
      end
    end

    # writes the data to android string.xml files
    def export
      @languages.each do |lang|
        folder = android_folder(lang)
        unless File.exist?(folder)
          Logging.logger.warn "Pompeu - creating folder for android language #{lang}: #{folder}"
          Dir.mkdir folder
        end
        file = android_file_path(lang)
        android_file = AndroidFile.from_text_db @textDB, lang
        android_file.to_files file
      end
    end

    def android_file_path lang
      "#{android_folder(lang)}/strings.xml"
    end

    def android_folder lang
      values_folder = lang==@default_language ? "values" : "values-#{lang}"
      "#{@android_path}#{values_folder}"
    end
  end
end