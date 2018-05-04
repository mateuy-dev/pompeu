module Pompeu
  class GooglePlaySource


    def initialize textDB, languages, play_data_path
      @textDB = textDB
      @languages = languages
      @play_data_path = play_data_path
    end

    #imports data form android xml files to the database
    def import
      @languages.each do |language|
        folder = lang_folder(language)
        next unless File.exist? folder
        google_play_data = GooglePlayData.from_files folder
        google_play_data.to_db @textDB, language.code
      end
    end

    # writes the data to android string.xml files
    def export app_name
      @languages.each do |language|
        folder = lang_folder(language)
        unless File.exist?(folder)
          Logging.logger.warn "Pompeu - creating folder for google play info for language #{language.code}: #{folder}"
          Dir.mkdir folder
        end
        google_play_data = GooglePlayData.from_db @textDB, language.code
        google_play_data.to_files folder, app_name
      end
    end


    def lang_folder language
      play_lang = language.for "googleplay"
      File.join @play_data_path, play_lang
    end

  end
end