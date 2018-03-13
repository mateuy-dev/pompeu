
#!/usr/bin/env ruby


require 'highline'


module Pompeu
  class PompeuOperations
    def initialize
      @pompeu = Pompeu.new
      @pompeu.load
      @pompeu_extractor = PompeuExtractor.new @pompeu
      @gengo = Gengo.new
    end

    def reload_from_android
      @pompeu.import_existing
      @pompeu.save
    end

    def export_android
      @pompeu.export_android
    end

    def export_for_gengo language, confidence
      texts = @pompeu_extractor.untranslated_or_worse_than language, confidence
      default_language = @pompeu.project_configuration["default_language"]
      puts @gengo.export(texts, default_language)
    end

    def auto_translate
      auto_translate = AutoTranslate.new @pompeu
      auto_translate.translate
    end

    def translate language
      default_language = @pompeu.project_configuration["default_language"]
      cli = HighLine.new
      texts = @pompeu_extractor.untranslated_or_worse_than language, TranslationConfidence::MANUAL
      texts.each do |key, text|
        proposed = text.text_in(language) ? text.text_in(language).text : ""
        english_text = text.text_in(default_language).text
        question = "Key: #{text.key}\n #{default_language}: #{english_text}\n #{language}: #{proposed}"

        new_translation = nil
        while !new_translation do
          input = cli.ask question
          if input!=""
            new_translation = input
          elsif proposed!=""
            new_translation = proposed
          end
        end
        @pompeu.textDB.add key, language, new_translation, confidence: TranslationConfidence::MANUAL
        logger.info "Stored: #{key} - #{language} - #{new_translation}"
        @pompeu.save
      end
    end

    def clear_db
      @pompeu.clear_db
    end

  end

end