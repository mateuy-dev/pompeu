require 'thor'
require 'pompeu'


module Pompeu
  include Logging

  class CLI < Thor
    desc "import", "adds changes from android strings files to the database"
    def import
      Logging.logger.info "text files -> DB"
      pompeu = Pompeu.new
      pompeu.import
      pompeu.save
    end

    desc "export", "exports the databse to android strings"
    def export
      Logging.logger.info "DB - text files"
      pompeu = Pompeu.new
      pompeu.export
    end

    desc "export_for_gengo [language]", "export the untranslated or bad translated texts for gengo translation"
    #option :language, :type => :string, required: true
    option :confidence, :type => :numeric, required: true
    option :target, :type => :string, required: true
    def export_for_gengo language
      confidence = options[:confidence]
      target = options[:target]
      Logging.logger.info "Exporting file for gengo for language #{language} and min confidence #{confidence}"
      pompeu = Pompeu.new
      pompeu.export_for_gengo language, confidence, target
    end

    desc "auto_translate", "Fills untranslated texts or updated ones with auto translated values. "
    option :update, type: :boolean, default: false
    def auto_translate
      confidence = options[:update] ? TranslationConfidence::AUTO + 1 : TranslationConfidence::AUTO
      Logging.logger.info "Translating database with min confidence #{confidence}"
      pompeu = Pompeu.new
      pompeu.auto_translate confidence
      pompeu.save
      Logging.logger.info "Database translated"
    end

    desc "auto_translate2check [language]", "Fills untranslated texts or updated ones with auto translated values. using double check"
    option :min_times, type: :numeric, default: 3
    option :update, type: :boolean, default: false
    def auto_translate language, min_times
      confidence = options[:update] ? TranslationConfidence::AUTO_2CHECK + 1 : TranslationConfidence::AUTO_2CHECK
      Logging.logger.info "Translating database with min confidence #{confidence}"
      pompeu = Pompeu.new
      pompeu.auto_translate_double_check language, min_times
      pompeu.save
      Logging.logger.info "Database translated"
    end

    desc "translate [language]", "translate"
    def translate language
      pompeu = Pompeu.new
      pompeu.interactive_translate language
      pompeu.save
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
      pompeu = Pompeu.new
      pompeu.clear_database
    end
  end
end