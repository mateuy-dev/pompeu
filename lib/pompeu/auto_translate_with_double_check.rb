module Pompeu
  class AutoTranslateWithDoubleCheck
    include Logging
    attr_accessor :translator

    def initialize(text_db, default_language, inner_translator)
      @text_db = text_db
      @default_language = default_language

      @translator = AutoTranslatorWithDoubleCheck.new inner_translator
    end

    def translate origin_langs, end_lang, min_times, min_quality = TranslationConfidence::AUTO_2CHECK
      counter = 0
      texts = @text_db.untranslated_or_worse_than end_lang, @default_language, min_quality
      texts.each do |text|
        translation, times = @translator.translate origin_langs, text, end_lang
        if times >= min_times
          logger.info "Pompeu - auto translate dchk: #{times} #{translation}"
          text.add_translation end_lang, translation, TranslationConfidence::AUTO_2CHECK if translation
          counter += 1
        else
          logger.info "Pompeu - auto translate dchk: Skip (#{times}) #{translation}"
        end
      end
      logger.info "Pompeu - auto translate dchk summary"
      logger.info "Pompeu - translated: #{counter}"
      logger.info "Pompeu - not translated: #{texts.size - counter}"
    end
  end
end