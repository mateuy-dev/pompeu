module Pompeu
  class RailsSource
  def initialize textDB, languages, rails_path, target
      @textDB = textDB
      @languages = languages
      @rails_path = rails_path
      @target = target
    end

    #imports data form rails yaml files to the database
    def import
      @languages.each do |language|
        file = rails_file_path(language)
        next unless File.exist? file
        rails_file = RailsFile.from_files file, language, @target
        rails_file.to_db @textDB, language.code
      end
    end

    # writes the data to rails yaml files
    def export(_appname=nil)
      @languages.each do |language|
        file = rails_file_path(language)
        rails_file = RailsFile.from_db @textDB, language.code, @target
        rails_file.to_files file, language
      end
    end

    def rails_file_path language
      rails_lang = language.for "rails"
      File.join @rails_path, "#{rails_lang}.yml"
    end
  end
end