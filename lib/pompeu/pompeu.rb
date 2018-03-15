
require 'rubygems'
require 'yaml'
require 'nokogiri'


module Pompeu
  include Logging



  class Pompeu
    attr_accessor :project_configuration, :textDB
    def initialize configuration_file = "project_configuration.yml"
      @project_configuration = YAML.load_file(configuration_file)
      load
    end

    def db_path
      @project_configuration["paths"]["db"]
    end


    def languages
      @project_configuration["languages"]
    end
    def load
      if File.file? db_path
        @textDB = File.open(db_path) { |file| YAML::load( file ) }
      else
        @textDB = TextDB.new
      end
    end

    def save
      File.open(db_path, 'w') do |file|
        YAML.dump(@textDB, file)
      end
    end

    def clear_db
      File.delete db_path
    end




    # Returns a Text given its key
    def text_for_key key
      @textDB.texts[key]
    end
  end

  Logging.logger.warn "Pompeu - translatable are not updated"
  Logging.logger.warn "Pompeu - removed texts are not removed"
end



