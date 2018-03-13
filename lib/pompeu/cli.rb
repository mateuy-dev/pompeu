require 'thor'
require 'pompeu'


module Pompeu
  include Logging

  class CLI < Thor
    desc "reload_from_android", "adds changes from android strings files to the database"
    def reload_from_android
      Logging.logger.info "android files -> DB"
      PompeuOperations.new.reload_from_android
    end

    desc "export_android", "exports the databse to android strings"
    def export_android
      Logging.logger.info "DB - android files"
      PompeuOperations.new.export_android
    end

    desc "export_for_gengo", "export the untranslated or bad translated texts for gengo translation"
    #option :language, :type => :string, required: true
    option :confidence, :type => :numeric, required: true
    def export_for_gengo language
      confidence = options[:confidence]
      Logging.logger.info "Exporting file for gengo gor language #{language} and min confidence #{confidence}"
      PompeuOperations.new.export_for_gengo language, confidence
    end

    desc "auto_translate", "fills all the untranslated texts with auto translated values"
    def auto_translate
      Logging.logger.info "Translating database..."
      PompeuOperations.new.auto_translate
      Logging.logger.info "Database translated"
    end

    desc "translate", "translate"
    def translate language
      PompeuOperations.new.translate language
    end


    desc "clear_db", "export the untranslated or bad translated texts for gengo translation"
    #option :language, :type => :string, required: true
    option :confirm, :type => :boolean
    def clear_db
      if !options[:confirm]
        Logging.logger.info "Confirmation needed"
        exit
      end
      Logging.logger.info "Deleting Pompeu database"
      PompeuOperations.new.clear_db
    end
  end
end