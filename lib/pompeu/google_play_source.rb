module Pompeu
  class GooglePlaySource


    def initialize textDB, languages, play_data_path
      @textDB = textDB
      @languages = languages
      @play_data_path = play_data_path
    end

    #imports data form android xml files to the database
    def import_all
      @languages.each do |language|
        import language
      end
    end

    def import language
      google_play_data = GooglePlayData.from_files @play_data_path, language
      google_play_data.to_db @textDB
    end

    # writes the data to android string.xml files
    def export app_name
      @languages.each do |language|
        google_play_data = GooglePlayData.from_db @textDB, language
        google_play_data.to_files @play_data_path, app_name
      end
    end



  end
end