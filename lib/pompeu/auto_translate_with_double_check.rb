
module Pompeu
  class AutoTranslateWithDoubleCheck
    include Logging
    attr_accessor :translator
    def initialize(text_db, default_language, cache = nil)
      @text_db = text_db
      @default_language = default_language

      @google_free_translator = GoogleFreeTranslator.new cache
      @translator = AutoTranslatorWithDoubleCheck.new @google_free_translator
    end
    def translate origin_langs, end_lang, min_times, min_quality = TranslationConfidence::AUTO_2CHECK
      texts = @text_db.untranslated_or_worse_than end_lang, @default_language, min_quality
      texts.each do |text|
        translation, times = @translator.translate origin_langs, text, end_lang
        if times >= min_times
          logger.info "Pompeu - auto translate dchk: #{times} #{translation}"
          text.add_translation end_lang, translation, TranslationConfidence::AUTO_2CHECK if translation
        else
          logger.info "Pompeu - auto translate dchk: Skip (#{times}) #{translation}"
        end
      end
    end
  end
end