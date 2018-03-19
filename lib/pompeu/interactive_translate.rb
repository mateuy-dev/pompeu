
#!/usr/bin/env ruby


require 'highline'


module Pompeu
  class InteractiveTranslate
    def initialize text_db, default_language
      @text_db = text_db
      @default_language = default_language
    end
    
    def translate language
      cli = HighLine.new
      pompeu_extractor = PompeuExtractor.new @text_db
      texts = pompeu_extractor.untranslated_or_worse_than language, TranslationConfidence::MANUAL
      texts.each do |key, text|
        proposed = text.text_in(language) ? text.text_in(language).text : ""
        english_text = text.text_in(@default_language).text
        question = "Key: #{text.key}\n #{@default_language}: #{english_text}\n #{language}: #{proposed}"

        new_translation = nil
        while !new_translation do
          input = cli.ask question
          if input!=""
            new_translation = input
          elsif proposed!=""
            new_translation = proposed
          end
        end
        @text_db.add key, language, new_translation, confidence: TranslationConfidence::MANUAL
        logger.info "Stored: #{key} - #{language} - #{new_translation}"
      end
    end
  end

end