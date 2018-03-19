module Pompeu
  class GooglePlaySource


    def initialize textDB, languages, play_data_path
      @textDB = textDB
      @languages = languages
      @play_data_path = play_data_path
    end

    #imports data form android xml files to the database
    def import
      @languages.keys.each do |lang|
        folder = lang_folder(lang)
        next unless File.exist? folder
        google_play_data = GooglePlayData.from_files folder
        google_play_data.to_db @textDB, lang
      end
    end

    # writes the data to android string.xml files
    def export
      @languages.keys.each do |lang|
        folder = lang_folder(lang)
        unless File.exist?(folder)
          Logging.logger.warn "Pompeu - creating folder for google play info for language #{lang}: #{folder}"
          Dir.mkdir folder
        end
        google_play_data = GooglePlayData.from_db @textDB, lang
        google_play_data.to_files folder
      end
    end


    def lang_folder lang
      play_lang = @languages[lang]["googleplay"]
      File.join @play_data_path, play_lang
    end
  end
end